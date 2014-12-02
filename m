Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbaLBTZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:25:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaLBTZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:25:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 097/121] ASoC: dpcm: Fix race between FE/BE updates and trigger
Date: Tue,  2 Dec 2014 11:19:36 -0800
Message-Id: <1417548000-1794-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ea9d0d771fcd32cd56070819749477d511ec9117 upstream.

DPCM can update the FE/BE connection states totally asynchronously
from the FE's PCM state.  Most of FE/BE state changes are protected by
mutex, so that they won't race, but there are still some actions that
are uncovered.  For example, suppose to switch a BE while a FE's
stream is running.  This would call soc_dpcm_runtime_update(), which
sets FE's runtime_update flag, then sets up and starts BEs, and clears
FE's runtime_update flag again.

When a device emits XRUN during this operation, the PCM core triggers
snd_pcm_stop(XRUN).  Since the trigger action is an atomic ops, this
isn't blocked by the mutex, thus it kicks off DPCM's trigger action.
It eventually updates and clears FE's runtime_update flag while
soc_dpcm_runtime_update() is running concurrently, and it results in
confusion.

Usually, for avoiding such a race, we take a lock.  There is a PCM
stream lock for that purpose.  However, as already mentioned, the
trigger action is atomic, and we can't take the lock for the whole
soc_dpcm_runtime_update() or other operations that include the lengthy
jobs like hw_params or prepare.

This patch provides an alternative solution.  This adds a way to defer
the conflicting trigger callback to be executed at the end of FE/BE
state changes.  For doing it, two things are introduced:

- Each runtime_update state change of FEs is protected via PCM stream
  lock.
- The FE's trigger callback checks the runtime_update flag.  If it's
  not set, the trigger action is executed there.  If set, mark the
  pending trigger action and returns immediately.
- At the exit of runtime_update state change, it checks whether the
  pending trigger is present.  If yes, it executes the trigger action
  at this point.

Reported-and-tested-by: Qiao Zhou <zhouqiao@marvell.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/sound/soc-dpcm.h |  2 ++
 sound/soc/soc-pcm.c      | 72 +++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/include/sound/soc-dpcm.h b/include/sound/soc-dpcm.h
index 047d657..3007641 100644
--- a/include/sound/soc-dpcm.h
+++ b/include/sound/soc-dpcm.h
@@ -101,6 +101,8 @@ struct snd_soc_dpcm_runtime {
 	/* state and update */
 	enum snd_soc_dpcm_update runtime_update;
 	enum snd_soc_dpcm_state state;
+
+	int trigger_pending; /* trigger cmd + 1 if pending, 0 if not */
 };
 
 /* can this BE stop and free */
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index e683959..d1c0b5e 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1155,13 +1155,36 @@ static void dpcm_set_fe_runtime(struct snd_pcm_substream *substream)
 	}
 }
 
+static int dpcm_fe_dai_do_trigger(struct snd_pcm_substream *substream, int cmd);
+
+/* Set FE's runtime_update state; the state is protected via PCM stream lock
+ * for avoiding the race with trigger callback.
+ * If the state is unset and a trigger is pending while the previous operation,
+ * process the pending trigger action here.
+ */
+static void dpcm_set_fe_update_state(struct snd_soc_pcm_runtime *fe,
+				     int stream, enum snd_soc_dpcm_update state)
+{
+	struct snd_pcm_substream *substream =
+		snd_soc_dpcm_get_substream(fe, stream);
+
+	snd_pcm_stream_lock_irq(substream);
+	if (state == SND_SOC_DPCM_UPDATE_NO && fe->dpcm[stream].trigger_pending) {
+		dpcm_fe_dai_do_trigger(substream,
+				       fe->dpcm[stream].trigger_pending - 1);
+		fe->dpcm[stream].trigger_pending = 0;
+	}
+	fe->dpcm[stream].runtime_update = state;
+	snd_pcm_stream_unlock_irq(substream);
+}
+
 static int dpcm_fe_dai_startup(struct snd_pcm_substream *fe_substream)
 {
 	struct snd_soc_pcm_runtime *fe = fe_substream->private_data;
 	struct snd_pcm_runtime *runtime = fe_substream->runtime;
 	int stream = fe_substream->stream, ret = 0;
 
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_FE;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_FE);
 
 	ret = dpcm_be_dai_startup(fe, fe_substream->stream);
 	if (ret < 0) {
@@ -1183,13 +1206,13 @@ static int dpcm_fe_dai_startup(struct snd_pcm_substream *fe_substream)
 	dpcm_set_fe_runtime(fe_substream);
 	snd_pcm_limit_hw_rates(runtime);
 
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_NO);
 	return 0;
 
 unwind:
 	dpcm_be_dai_startup_unwind(fe, fe_substream->stream);
 be_err:
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_NO);
 	return ret;
 }
 
@@ -1236,7 +1259,7 @@ static int dpcm_fe_dai_shutdown(struct snd_pcm_substream *substream)
 	struct snd_soc_pcm_runtime *fe = substream->private_data;
 	int stream = substream->stream;
 
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_FE;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_FE);
 
 	/* shutdown the BEs */
 	dpcm_be_dai_shutdown(fe, substream->stream);
@@ -1250,7 +1273,7 @@ static int dpcm_fe_dai_shutdown(struct snd_pcm_substream *substream)
 	dpcm_dapm_stream_event(fe, stream, SND_SOC_DAPM_STREAM_STOP);
 
 	fe->dpcm[stream].state = SND_SOC_DPCM_STATE_CLOSE;
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_NO);
 	return 0;
 }
 
@@ -1298,7 +1321,7 @@ static int dpcm_fe_dai_hw_free(struct snd_pcm_substream *substream)
 	int err, stream = substream->stream;
 
 	mutex_lock_nested(&fe->card->mutex, SND_SOC_CARD_CLASS_RUNTIME);
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_FE;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_FE);
 
 	dev_dbg(fe->dev, "ASoC: hw_free FE %s\n", fe->dai_link->name);
 
@@ -1313,7 +1336,7 @@ static int dpcm_fe_dai_hw_free(struct snd_pcm_substream *substream)
 	err = dpcm_be_dai_hw_free(fe, stream);
 
 	fe->dpcm[stream].state = SND_SOC_DPCM_STATE_HW_FREE;
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_NO);
 
 	mutex_unlock(&fe->card->mutex);
 	return 0;
@@ -1406,7 +1429,7 @@ static int dpcm_fe_dai_hw_params(struct snd_pcm_substream *substream,
 	int ret, stream = substream->stream;
 
 	mutex_lock_nested(&fe->card->mutex, SND_SOC_CARD_CLASS_RUNTIME);
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_FE;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_FE);
 
 	memcpy(&fe->dpcm[substream->stream].hw_params, params,
 			sizeof(struct snd_pcm_hw_params));
@@ -1429,7 +1452,7 @@ static int dpcm_fe_dai_hw_params(struct snd_pcm_substream *substream,
 		fe->dpcm[stream].state = SND_SOC_DPCM_STATE_HW_PARAMS;
 
 out:
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_NO);
 	mutex_unlock(&fe->card->mutex);
 	return ret;
 }
@@ -1543,7 +1566,7 @@ static int dpcm_be_dai_trigger(struct snd_soc_pcm_runtime *fe, int stream,
 }
 EXPORT_SYMBOL_GPL(dpcm_be_dai_trigger);
 
-static int dpcm_fe_dai_trigger(struct snd_pcm_substream *substream, int cmd)
+static int dpcm_fe_dai_do_trigger(struct snd_pcm_substream *substream, int cmd)
 {
 	struct snd_soc_pcm_runtime *fe = substream->private_data;
 	int stream = substream->stream, ret;
@@ -1617,6 +1640,23 @@ out:
 	return ret;
 }
 
+static int dpcm_fe_dai_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_soc_pcm_runtime *fe = substream->private_data;
+	int stream = substream->stream;
+
+	/* if FE's runtime_update is already set, we're in race;
+	 * process this trigger later at exit
+	 */
+	if (fe->dpcm[stream].runtime_update != SND_SOC_DPCM_UPDATE_NO) {
+		fe->dpcm[stream].trigger_pending = cmd + 1;
+		return 0; /* delayed, assuming it's successful */
+	}
+
+	/* we're alone, let's trigger */
+	return dpcm_fe_dai_do_trigger(substream, cmd);
+}
+
 static int dpcm_be_dai_prepare(struct snd_soc_pcm_runtime *fe, int stream)
 {
 	struct snd_soc_dpcm *dpcm;
@@ -1660,7 +1700,7 @@ static int dpcm_fe_dai_prepare(struct snd_pcm_substream *substream)
 
 	dev_dbg(fe->dev, "ASoC: prepare FE %s\n", fe->dai_link->name);
 
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_FE;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_FE);
 
 	/* there is no point preparing this FE if there are no BEs */
 	if (list_empty(&fe->dpcm[stream].be_clients)) {
@@ -1687,7 +1727,7 @@ static int dpcm_fe_dai_prepare(struct snd_pcm_substream *substream)
 	fe->dpcm[stream].state = SND_SOC_DPCM_STATE_PREPARE;
 
 out:
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_NO);
 	mutex_unlock(&fe->card->mutex);
 
 	return ret;
@@ -1834,11 +1874,11 @@ static int dpcm_run_new_update(struct snd_soc_pcm_runtime *fe, int stream)
 {
 	int ret;
 
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_BE;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_BE);
 	ret = dpcm_run_update_startup(fe, stream);
 	if (ret < 0)
 		dev_err(fe->dev, "ASoC: failed to startup some BEs\n");
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_NO);
 
 	return ret;
 }
@@ -1847,11 +1887,11 @@ static int dpcm_run_old_update(struct snd_soc_pcm_runtime *fe, int stream)
 {
 	int ret;
 
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_BE;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_BE);
 	ret = dpcm_run_update_shutdown(fe, stream);
 	if (ret < 0)
 		dev_err(fe->dev, "ASoC: failed to shutdown some BEs\n");
-	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
+	dpcm_set_fe_update_state(fe, stream, SND_SOC_DPCM_UPDATE_NO);
 
 	return ret;
 }
-- 
1.9.1

