Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaHUS4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:56:43 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:49209 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbaHUS4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:56:42 -0400
Message-ID: <53F64099.8000601@ladisch.de>
Date: Thu, 21 Aug 2014 20:55:21 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tommi Rantala <tt.rantala@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
CC: Dave Jones <davej@redhat.com>, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org
Subject: Re: [alsa-devel] /proc/asound/card0/oss_mixer stack corruption
References: <CA+ydwtr+e0Sr4y+VRu-3JkF0Lbf+KJqjO9LZq6JPOgbHuyfAwA@mail.gmail.com>
In-Reply-To: <CA+ydwtr+e0Sr4y+VRu-3JkF0Lbf+KJqjO9LZq6JPOgbHuyfAwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20140821185625.936109.29856@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tommi Rantala wrote:
> Trinity discovered that writing 128 bytes to
> /proc/asound/card0/oss_mixer triggers a stack corruption.
>
> Call Trace:
>  [<ffffffff8113c716>] __stack_chk_fail+0x16/0x20
>  [<ffffffff81e193ba>] snd_mixer_oss_proc_write+0x24a/0x270

snd_info_get_line() wants the len parameter to be one less than the
buffer size, but it isn't:

	while (!snd_info_get_line(buffer, line, sizeof(line))) {

Not that *any* other caller got it correct either:

sound/core/oss/pcm_oss.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/core/pcm.c:	if (!snd_info_get_line(buffer, line, sizeof(line)))
sound/core/pcm_memory.c:	if (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/drivers/dummy.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/ac97/ac97_proc.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/ca0106/ca0106_proc.c:        while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/ca0106/ca0106_proc.c:        while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/ca0106/ca0106_proc.c:        while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/emu10k1/emu10k1x.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/emu10k1/emuproc.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/emu10k1/emuproc.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/hda/hda_eld.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/ice1712/pontis.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/ice1712/prodigy_hifi.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/lola/lola_proc.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {
sound/pci/pcxhr/pcxhr.c:	while (!snd_info_get_line(buffer, line, sizeof(line))) {

Oh well.  At least these proc files are writable only by root, and the
fix is easy:

--8<---------------------------------------------------------------->8--
ALSA: core: fix buffer overflow in snd_info_get_line()

snd_info_get_line() documents that its last parameter must be one
less than the buffer size, but this API design guarantees that
(literally) every caller gets it wrong.

Just change this parameter to have its obvious meaning.

Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: <stable@vger.kernel.org> # v2.2.26+
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 sound/core/info.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -684,7 +684,7 @@ int snd_info_card_free(struct snd_card *card)
  * snd_info_get_line - read one line from the procfs buffer
  * @buffer: the procfs buffer
  * @line: the buffer to store
- * @len: the max. buffer size - 1
+ * @len: the max. buffer size
  *
  * Reads one line from the buffer and stores the string.
  *
@@ -704,7 +704,7 @@ int snd_info_get_line(struct snd_info_buffer *buffer, char *line, int len)
 			buffer->stop = 1;
 		if (c == '\n')
 			break;
-		if (len) {
+		if (len > 1) {
 			len--;
 			*line++ = c;
 		}
