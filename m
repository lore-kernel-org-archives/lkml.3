Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbbAQXfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:35:41 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:47874 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbbAQXfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:35:39 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jie Yang <yang.jie@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Engelmayer <cengelma@gmx.at>,
        =?UTF-8?q?Pawe=C5=82=20Piskorski?= <pawel.piskorski@intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] soc: intel: sst-haswell-ipc: Remove unused functions
Date: Sun, 18 Jan 2015 00:38:46 +0100
Message-Id: <1421537927-16567-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
sst_hsw_stream_unmute() sst_hsw_stream_mute() msg_set_stage_type()
sst_hsw_dx_get_state() sst_hsw_stream_set_write_position()
sst_hsw_stream_get_vol_reg() sst_hsw_stream_get_peak_reg()
sst_hsw_stream_get_pointer_reg() sst_hsw_stream_get_read_reg()
sst_hsw_stream_get_mixer_id() sst_hsw_stream_get_hw_id()
sst_hsw_mixer_set_volume_curve() sst_hsw_mixer_unmute()
sst_hsw_mixer_mute() sst_hsw_stream_set_volume_curve()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/soc/intel/sst-haswell-ipc.c |  168 -------------------------------------
 sound/soc/intel/sst-haswell-ipc.h |   31 -------
 2 files changed, 199 deletions(-)

diff --git a/sound/soc/intel/sst-haswell-ipc.c b/sound/soc/intel/sst-haswell-ipc.c
index 3f8c482..d693d4a 100644
--- a/sound/soc/intel/sst-haswell-ipc.c
+++ b/sound/soc/intel/sst-haswell-ipc.c
@@ -337,12 +337,6 @@ static inline u32 msg_get_stage_type(u32 msg)
 	return (msg & IPC_STG_TYPE_MASK) >>  IPC_STG_TYPE_SHIFT;
 }
 
-static inline u32 msg_set_stage_type(u32 msg, u32 type)
-{
-	return (msg & ~IPC_STG_TYPE_MASK) +
-		(type << IPC_STG_TYPE_SHIFT);
-}
-
 static inline u32 msg_get_stream_id(u32 msg)
 {
 	return (msg & IPC_STR_ID_MASK) >>  IPC_STR_ID_SHIFT;
@@ -969,45 +963,6 @@ int sst_hsw_fw_get_version(struct sst_hsw *hsw,
 }
 
 /* Mixer Controls */
-int sst_hsw_stream_mute(struct sst_hsw *hsw, struct sst_hsw_stream *stream,
-	u32 stage_id, u32 channel)
-{
-	int ret;
-
-	ret = sst_hsw_stream_get_volume(hsw, stream, stage_id, channel,
-		&stream->mute_volume[channel]);
-	if (ret < 0)
-		return ret;
-
-	ret = sst_hsw_stream_set_volume(hsw, stream, stage_id, channel, 0);
-	if (ret < 0) {
-		dev_err(hsw->dev, "error: can't unmute stream %d channel %d\n",
-			stream->reply.stream_hw_id, channel);
-		return ret;
-	}
-
-	stream->mute[channel] = 1;
-	return 0;
-}
-
-int sst_hsw_stream_unmute(struct sst_hsw *hsw, struct sst_hsw_stream *stream,
-	u32 stage_id, u32 channel)
-
-{
-	int ret;
-
-	stream->mute[channel] = 0;
-	ret = sst_hsw_stream_set_volume(hsw, stream, stage_id, channel,
-		stream->mute_volume[channel]);
-	if (ret < 0) {
-		dev_err(hsw->dev, "error: can't unmute stream %d channel %d\n",
-			stream->reply.stream_hw_id, channel);
-		return ret;
-	}
-
-	return 0;
-}
-
 int sst_hsw_stream_get_volume(struct sst_hsw *hsw, struct sst_hsw_stream *stream,
 	u32 stage_id, u32 channel, u32 *volume)
 {
@@ -1021,17 +976,6 @@ int sst_hsw_stream_get_volume(struct sst_hsw *hsw, struct sst_hsw_stream *stream
 	return 0;
 }
 
-int sst_hsw_stream_set_volume_curve(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream, u64 curve_duration,
-	enum sst_hsw_volume_curve curve)
-{
-	/* curve duration in steps of 100ns */
-	stream->vol_req.curve_duration = curve_duration;
-	stream->vol_req.curve_type = curve;
-
-	return 0;
-}
-
 /* stream volume */
 int sst_hsw_stream_set_volume(struct sst_hsw *hsw,
 	struct sst_hsw_stream *stream, u32 stage_id, u32 channel, u32 volume)
@@ -1083,42 +1027,6 @@ int sst_hsw_stream_set_volume(struct sst_hsw *hsw,
 	return 0;
 }
 
-int sst_hsw_mixer_mute(struct sst_hsw *hsw, u32 stage_id, u32 channel)
-{
-	int ret;
-
-	ret = sst_hsw_mixer_get_volume(hsw, stage_id, channel,
-		&hsw->mute_volume[channel]);
-	if (ret < 0)
-		return ret;
-
-	ret = sst_hsw_mixer_set_volume(hsw, stage_id, channel, 0);
-	if (ret < 0) {
-		dev_err(hsw->dev, "error: failed to unmute mixer channel %d\n",
-			channel);
-		return ret;
-	}
-
-	hsw->mute[channel] = 1;
-	return 0;
-}
-
-int sst_hsw_mixer_unmute(struct sst_hsw *hsw, u32 stage_id, u32 channel)
-{
-	int ret;
-
-	ret = sst_hsw_mixer_set_volume(hsw, stage_id, channel,
-		hsw->mixer_info.volume_register_address[channel]);
-	if (ret < 0) {
-		dev_err(hsw->dev, "error: failed to unmute mixer channel %d\n",
-			channel);
-		return ret;
-	}
-
-	hsw->mute[channel] = 0;
-	return 0;
-}
-
 int sst_hsw_mixer_get_volume(struct sst_hsw *hsw, u32 stage_id, u32 channel,
 	u32 *volume)
 {
@@ -1132,16 +1040,6 @@ int sst_hsw_mixer_get_volume(struct sst_hsw *hsw, u32 stage_id, u32 channel,
 	return 0;
 }
 
-int sst_hsw_mixer_set_volume_curve(struct sst_hsw *hsw,
-	 u64 curve_duration, enum sst_hsw_volume_curve curve)
-{
-	/* curve duration in steps of 100ns */
-	hsw->curve_duration = curve_duration;
-	hsw->curve_type = curve;
-
-	return 0;
-}
-
 /* global mixer volume */
 int sst_hsw_mixer_set_volume(struct sst_hsw *hsw, u32 stage_id, u32 channel,
 	u32 volume)
@@ -1434,48 +1332,6 @@ int sst_hsw_stream_commit(struct sst_hsw *hsw, struct sst_hsw_stream *stream)
 
 /* Stream Information - these calls could be inline but we want the IPC
  ABI to be opaque to client PCM drivers to cope with any future ABI changes */
-int sst_hsw_stream_get_hw_id(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream)
-{
-	return stream->reply.stream_hw_id;
-}
-
-int sst_hsw_stream_get_mixer_id(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream)
-{
-	return stream->reply.mixer_hw_id;
-}
-
-u32 sst_hsw_stream_get_read_reg(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream)
-{
-	return stream->reply.read_position_register_address;
-}
-
-u32 sst_hsw_stream_get_pointer_reg(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream)
-{
-	return stream->reply.presentation_position_register_address;
-}
-
-u32 sst_hsw_stream_get_peak_reg(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream, u32 channel)
-{
-	if (channel >= 2)
-		return 0;
-
-	return stream->reply.peak_meter_register_address[channel];
-}
-
-u32 sst_hsw_stream_get_vol_reg(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream, u32 channel)
-{
-	if (channel >= 2)
-		return 0;
-
-	return stream->reply.volume_register_address[channel];
-}
-
 int sst_hsw_mixer_get_info(struct sst_hsw *hsw)
 {
 	struct sst_hsw_ipc_stream_info_reply *reply;
@@ -1598,30 +1454,6 @@ u64 sst_hsw_get_dsp_presentation_position(struct sst_hsw *hsw,
 	return ppos;
 }
 
-int sst_hsw_stream_set_write_position(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream, u32 stage_id, u32 position)
-{
-	u32 header;
-	int ret;
-
-	trace_stream_write_position(stream->reply.stream_hw_id, position);
-
-	header = IPC_GLB_TYPE(IPC_GLB_STREAM_MESSAGE) |
-		IPC_STR_TYPE(IPC_STR_STAGE_MESSAGE);
-	header |= (stream->reply.stream_hw_id << IPC_STR_ID_SHIFT);
-	header |= (IPC_STG_SET_WRITE_POSITION << IPC_STG_TYPE_SHIFT);
-	header |= (stage_id << IPC_STG_ID_SHIFT);
-	stream->wpos.position = position;
-
-	ret = ipc_tx_message_nowait(hsw, header, &stream->wpos,
-		sizeof(stream->wpos));
-	if (ret < 0)
-		dev_err(hsw->dev, "error: stream %d set position %d failed\n",
-			stream->reply.stream_hw_id, position);
-
-	return ret;
-}
-
 /* physical BE config */
 int sst_hsw_device_set_config(struct sst_hsw *hsw,
 	enum sst_hsw_device_id dev, enum sst_hsw_device_mclk mclk,
diff --git a/sound/soc/intel/sst-haswell-ipc.h b/sound/soc/intel/sst-haswell-ipc.h
index 138e894..c1ad901 100644
--- a/sound/soc/intel/sst-haswell-ipc.h
+++ b/sound/soc/intel/sst-haswell-ipc.h
@@ -376,32 +376,17 @@ int sst_hsw_fw_get_version(struct sst_hsw *hsw,
 u32 create_channel_map(enum sst_hsw_channel_config config);
 
 /* Stream Mixer Controls - */
-int sst_hsw_stream_mute(struct sst_hsw *hsw, struct sst_hsw_stream *stream,
-	u32 stage_id, u32 channel);
-int sst_hsw_stream_unmute(struct sst_hsw *hsw, struct sst_hsw_stream *stream,
-	u32 stage_id, u32 channel);
-
 int sst_hsw_stream_set_volume(struct sst_hsw *hsw,
 	struct sst_hsw_stream *stream, u32 stage_id, u32 channel, u32 volume);
 int sst_hsw_stream_get_volume(struct sst_hsw *hsw,
 	struct sst_hsw_stream *stream, u32 stage_id, u32 channel, u32 *volume);
 
-int sst_hsw_stream_set_volume_curve(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream, u64 curve_duration,
-	enum sst_hsw_volume_curve curve);
-
 /* Global Mixer Controls - */
-int sst_hsw_mixer_mute(struct sst_hsw *hsw, u32 stage_id, u32 channel);
-int sst_hsw_mixer_unmute(struct sst_hsw *hsw, u32 stage_id, u32 channel);
-
 int sst_hsw_mixer_set_volume(struct sst_hsw *hsw, u32 stage_id, u32 channel,
 	u32 volume);
 int sst_hsw_mixer_get_volume(struct sst_hsw *hsw, u32 stage_id, u32 channel,
 	u32 *volume);
 
-int sst_hsw_mixer_set_volume_curve(struct sst_hsw *hsw,
-	u64 curve_duration, enum sst_hsw_volume_curve curve);
-
 /* Stream API */
 struct sst_hsw_stream *sst_hsw_stream_new(struct sst_hsw *hsw, int id,
 	u32 (*get_write_position)(struct sst_hsw_stream *stream, void *data),
@@ -440,18 +425,6 @@ int sst_hsw_stream_set_pmemory_info(struct sst_hsw *hsw,
 	struct sst_hsw_stream *stream, u32 offset, u32 size);
 int sst_hsw_stream_set_smemory_info(struct sst_hsw *hsw,
 	struct sst_hsw_stream *stream, u32 offset, u32 size);
-int sst_hsw_stream_get_hw_id(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream);
-int sst_hsw_stream_get_mixer_id(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream);
-u32 sst_hsw_stream_get_read_reg(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream);
-u32 sst_hsw_stream_get_pointer_reg(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream);
-u32 sst_hsw_stream_get_peak_reg(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream, u32 channel);
-u32 sst_hsw_stream_get_vol_reg(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream, u32 channel);
 int sst_hsw_mixer_get_info(struct sst_hsw *hsw);
 
 /* Stream ALSA trigger operations */
@@ -466,8 +439,6 @@ int sst_hsw_stream_get_read_pos(struct sst_hsw *hsw,
 	struct sst_hsw_stream *stream, u32 *position);
 int sst_hsw_stream_get_write_pos(struct sst_hsw *hsw,
 	struct sst_hsw_stream *stream, u32 *position);
-int sst_hsw_stream_set_write_position(struct sst_hsw *hsw,
-	struct sst_hsw_stream *stream, u32 stage_id, u32 position);
 u32 sst_hsw_get_dsp_position(struct sst_hsw *hsw,
 	struct sst_hsw_stream *stream);
 u64 sst_hsw_get_dsp_presentation_position(struct sst_hsw *hsw,
@@ -481,8 +452,6 @@ int sst_hsw_device_set_config(struct sst_hsw *hsw,
 /* DX Config */
 int sst_hsw_dx_set_state(struct sst_hsw *hsw,
 	enum sst_hsw_dx_state state, struct sst_hsw_ipc_dx_reply *dx);
-int sst_hsw_dx_get_state(struct sst_hsw *hsw, u32 item,
-	u32 *offset, u32 *size, u32 *source);
 
 /* init */
 int sst_hsw_dsp_init(struct device *dev, struct sst_pdata *pdata);
-- 
1.7.10.4

