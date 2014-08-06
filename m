Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaHFMuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:50:07 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33983 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaHFMuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:50:05 -0400
Date: Wed, 6 Aug 2014 18:20:01 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] sound: oss: Remove typedefs wanc_info and wavnc_port_info
Message-ID: <20140806125000.GA7977@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedefs for wanc_info and
wavnc_port_info.

A simplified version of the Coccinelle semantic patch that finds the case is:

@tn@
identifier i;
type td;
@@

-typedef
 struct i { ... }
-td
 ;

@@
type tn.td;
identifier tn.i;
@@

-td
+ struct i

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 sound/oss/waveartist.c | 157 ++++++++++++++++++++++++++++---------------------
 1 file changed, 89 insertions(+), 68 deletions(-)

diff --git a/sound/oss/waveartist.c b/sound/oss/waveartist.c
index 672af8b..b36ea47 100644
--- a/sound/oss/waveartist.c
+++ b/sound/oss/waveartist.c
@@ -92,7 +92,7 @@ static unsigned short levels[SOUND_MIXER_NRDEVICES] = {
 	0x0000		/* Monitor		 */
 };
 
-typedef struct {
+struct wavnc_info {
 	struct address_info  hw;	/* hardware */
 	char		*chip_name;
 
@@ -119,7 +119,7 @@ typedef struct {
 	unsigned int	line_mute_state	:1;/* set by ioctl or autoselect */
 	unsigned int	use_slider	:1;/* use slider setting for o/p vol */
 #endif
-} wavnc_info;
+};
 
 /*
  * This is the implementation specific mixer information.
@@ -129,29 +129,30 @@ struct waveartist_mixer_info {
 	unsigned int	recording_devs;	   /* Recordable devies */
 	unsigned int	stereo_devs;	   /* Stereo devices	*/
 
-	unsigned int	(*select_input)(wavnc_info *, unsigned int,
+	unsigned int	(*select_input)(struct wavnc_info *, unsigned int,
 					unsigned char *, unsigned char *);
-	int		(*decode_mixer)(wavnc_info *, int,
+	int		(*decode_mixer)(struct wavnc_info *, int,
 					unsigned char, unsigned char);
-	int		(*get_mixer)(wavnc_info *, int);
+	int		(*get_mixer)(struct wavnc_info *, int);
 };
 
-typedef struct wavnc_port_info {
+struct wavnc_port_info {
 	int		open_mode;
 	int		speed;
 	int		channels;
 	int		audio_format;
-} wavnc_port_info;
+};
 
 static int		nr_waveartist_devs;
-static wavnc_info	adev_info[MAX_AUDIO_DEV];
+static struct wavnc_info	adev_info[MAX_AUDIO_DEV];
 static DEFINE_SPINLOCK(waveartist_lock);
 
 #ifndef CONFIG_ARCH_NETWINDER
 #define machine_is_netwinder() 0
 #else
 static struct timer_list vnc_timer;
-static void vnc_configure_mixer(wavnc_info *devc, unsigned int input_mask);
+static void vnc_configure_mixer(struct wavnc_info *devc,
+				unsigned int input_mask);
 static int vnc_private_ioctl(int dev, unsigned int cmd, int __user *arg);
 static void vnc_slider_tick(unsigned long data);
 #endif
@@ -169,7 +170,7 @@ waveartist_set_ctlr(struct address_info *hw, unsigned char clear, unsigned char
 /* Toggle IRQ acknowledge line
  */
 static inline void
-waveartist_iack(wavnc_info *devc)
+waveartist_iack(struct wavnc_info *devc)
 {
 	unsigned int ctlr_port = devc->hw.io_base + CTLR;
 	int old_ctlr;
@@ -188,7 +189,7 @@ waveartist_sleep(int timeout_ms)
 }
 
 static int
-waveartist_reset(wavnc_info *devc)
+waveartist_reset(struct wavnc_info *devc)
 {
 	struct address_info *hw = &devc->hw;
 	unsigned int timeout, res = -1;
@@ -223,7 +224,7 @@ waveartist_reset(wavnc_info *devc)
  * and can send or receive multiple words.
  */
 static int
-waveartist_cmd(wavnc_info *devc,
+waveartist_cmd(struct wavnc_info *devc,
 		int nr_cmd, unsigned int *cmd,
 		int nr_resp, unsigned int *resp)
 {
@@ -299,7 +300,7 @@ waveartist_cmd(wavnc_info *devc,
  * Send one command word
  */
 static inline int
-waveartist_cmd1(wavnc_info *devc, unsigned int cmd)
+waveartist_cmd1(struct wavnc_info *devc, unsigned int cmd)
 {
 	return waveartist_cmd(devc, 1, &cmd, 0, NULL);
 }
@@ -308,7 +309,7 @@ waveartist_cmd1(wavnc_info *devc, unsigned int cmd)
  * Send one command, receive one word
  */
 static inline unsigned int
-waveartist_cmd1_r(wavnc_info *devc, unsigned int cmd)
+waveartist_cmd1_r(struct wavnc_info *devc, unsigned int cmd)
 {
 	unsigned int ret;
 
@@ -322,7 +323,7 @@ waveartist_cmd1_r(wavnc_info *devc, unsigned int cmd)
  * word (and throw it away)
  */
 static inline int
-waveartist_cmd2(wavnc_info *devc, unsigned int cmd, unsigned int arg)
+waveartist_cmd2(struct wavnc_info *devc, unsigned int cmd, unsigned int arg)
 {
 	unsigned int vals[2];
 
@@ -336,7 +337,7 @@ waveartist_cmd2(wavnc_info *devc, unsigned int cmd, unsigned int arg)
  * Send a triple command
  */
 static inline int
-waveartist_cmd3(wavnc_info *devc, unsigned int cmd,
+waveartist_cmd3(struct wavnc_info *devc, unsigned int cmd,
 		unsigned int arg1, unsigned int arg2)
 {
 	unsigned int vals[3];
@@ -349,7 +350,7 @@ waveartist_cmd3(wavnc_info *devc, unsigned int cmd,
 }
 
 static int
-waveartist_getrev(wavnc_info *devc, char *rev)
+waveartist_getrev(struct wavnc_info *devc, char *rev)
 {
 	unsigned int temp[2];
 	unsigned int cmd = WACMD_GETREV;
@@ -371,15 +372,15 @@ static void waveartist_trigger(int dev, int state);
 static int
 waveartist_open(int dev, int mode)
 {
-	wavnc_info	*devc;
-	wavnc_port_info	*portc;
+	struct wavnc_info	*devc;
+	struct wavnc_port_info	*portc;
 	unsigned long	flags;
 
 	if (dev < 0 || dev >= num_audiodevs)
 		return -ENXIO;
 
-	devc  = (wavnc_info *) audio_devs[dev]->devc;
-	portc = (wavnc_port_info *) audio_devs[dev]->portc;
+	devc  = (struct wavnc_info *) audio_devs[dev]->devc;
+	portc = (struct wavnc_port_info *) audio_devs[dev]->portc;
 
 	spin_lock_irqsave(&waveartist_lock, flags);
 	if (portc->open_mode || (devc->open_mode & mode)) {
@@ -404,8 +405,10 @@ waveartist_open(int dev, int mode)
 static void
 waveartist_close(int dev)
 {
-	wavnc_info	*devc = (wavnc_info *) audio_devs[dev]->devc;
-	wavnc_port_info	*portc = (wavnc_port_info *) audio_devs[dev]->portc;
+	struct wavnc_info	*devc = (struct wavnc_info *)
+					audio_devs[dev]->devc;
+	struct wavnc_port_info	*portc = (struct wavnc_port_info *)
+					 audio_devs[dev]->portc;
 	unsigned long	flags;
 
 	spin_lock_irqsave(&waveartist_lock, flags);
@@ -422,8 +425,10 @@ waveartist_close(int dev)
 static void
 waveartist_output_block(int dev, unsigned long buf, int __count, int intrflag)
 {
-	wavnc_port_info	*portc = (wavnc_port_info *) audio_devs[dev]->portc;
-	wavnc_info	*devc = (wavnc_info *) audio_devs[dev]->devc;
+	struct wavnc_port_info	*portc = (struct wavnc_port_info *)
+					 audio_devs[dev]->portc;
+	struct wavnc_info	*devc = (struct wavnc_info *)
+					audio_devs[dev]->devc;
 	unsigned long	flags;
 	unsigned int	count = __count; 
 
@@ -467,8 +472,10 @@ waveartist_output_block(int dev, unsigned long buf, int __count, int intrflag)
 static void
 waveartist_start_input(int dev, unsigned long buf, int __count, int intrflag)
 {
-	wavnc_port_info *portc = (wavnc_port_info *) audio_devs[dev]->portc;
-	wavnc_info	*devc = (wavnc_info *) audio_devs[dev]->devc;
+	struct wavnc_port_info *portc = (struct wavnc_port_info *)
+					audio_devs[dev]->portc;
+	struct wavnc_info	*devc = (struct wavnc_info *)
+					audio_devs[dev]->devc;
 	unsigned long	flags;
 	unsigned int	count = __count;
 
@@ -514,7 +521,7 @@ waveartist_ioctl(int dev, unsigned int cmd, void __user * arg)
 }
 
 static unsigned int
-waveartist_get_speed(wavnc_port_info *portc)
+waveartist_get_speed(struct wavnc_port_info *portc)
 {
 	unsigned int speed;
 
@@ -542,7 +549,7 @@ waveartist_get_speed(wavnc_port_info *portc)
 }
 
 static unsigned int
-waveartist_get_bits(wavnc_port_info *portc)
+waveartist_get_bits(struct wavnc_port_info *portc)
 {
 	unsigned int bits;
 
@@ -560,8 +567,10 @@ static int
 waveartist_prepare_for_input(int dev, int bsize, int bcount)
 {
 	unsigned long	flags;
-	wavnc_info	*devc = (wavnc_info *) audio_devs[dev]->devc;
-	wavnc_port_info	*portc = (wavnc_port_info *) audio_devs[dev]->portc;
+	struct wavnc_info	*devc = (struct wavnc_info *)
+					audio_devs[dev]->devc;
+	struct wavnc_port_info	*portc = (struct wavnc_port_info *)
+					 audio_devs[dev]->portc;
 	unsigned int	speed, bits;
 
 	if (devc->audio_mode)
@@ -615,8 +624,10 @@ static int
 waveartist_prepare_for_output(int dev, int bsize, int bcount)
 {
 	unsigned long	flags;
-	wavnc_info	*devc = (wavnc_info *) audio_devs[dev]->devc;
-	wavnc_port_info	*portc = (wavnc_port_info *) audio_devs[dev]->portc;
+	struct wavnc_info	*devc = (struct wavnc_info *)
+					audio_devs[dev]->devc;
+	struct wavnc_port_info	*portc = (struct wavnc_port_info *)
+					 audio_devs[dev]->portc;
 	unsigned int	speed, bits;
 
 	/*
@@ -660,8 +671,9 @@ waveartist_prepare_for_output(int dev, int bsize, int bcount)
 static void
 waveartist_halt(int dev)
 {
-	wavnc_port_info	*portc = (wavnc_port_info *) audio_devs[dev]->portc;
-	wavnc_info	*devc;
+	struct wavnc_port_info	*portc = (struct wavnc_port_info *)
+					 audio_devs[dev]->portc;
+	struct wavnc_info	*devc;
 
 	if (portc->open_mode & OPEN_WRITE)
 		waveartist_halt_output(dev);
@@ -669,14 +681,15 @@ waveartist_halt(int dev)
 	if (portc->open_mode & OPEN_READ)
 		waveartist_halt_input(dev);
 
-	devc = (wavnc_info *) audio_devs[dev]->devc;
+	devc = (struct wavnc_info *) audio_devs[dev]->devc;
 	devc->audio_mode = 0;
 }
 
 static void
 waveartist_halt_input(int dev)
 {
-	wavnc_info	*devc = (wavnc_info *) audio_devs[dev]->devc;
+	struct wavnc_info	*devc = (struct wavnc_info *)
+					audio_devs[dev]->devc;
 	unsigned long	flags;
 
 	spin_lock_irqsave(&waveartist_lock, flags);
@@ -703,7 +716,8 @@ waveartist_halt_input(int dev)
 static void
 waveartist_halt_output(int dev)
 {
-	wavnc_info	*devc = (wavnc_info *) audio_devs[dev]->devc;
+	struct wavnc_info	*devc = (struct wavnc_info *)
+					audio_devs[dev]->devc;
 	unsigned long	flags;
 
 	spin_lock_irqsave(&waveartist_lock, flags);
@@ -727,8 +741,10 @@ waveartist_halt_output(int dev)
 static void
 waveartist_trigger(int dev, int state)
 {
-	wavnc_info	*devc = (wavnc_info *) audio_devs[dev]->devc;
-	wavnc_port_info	*portc = (wavnc_port_info *) audio_devs[dev]->portc;
+	struct wavnc_info	*devc = (struct wavnc_info *)
+					audio_devs[dev]->devc;
+	struct wavnc_port_info	*portc = (struct wavnc_port_info *)
+					 audio_devs[dev]->portc;
 	unsigned long	flags;
 
 	if (debug_flg & DEBUG_TRIGGER) {
@@ -764,7 +780,8 @@ waveartist_trigger(int dev, int state)
 static int
 waveartist_set_speed(int dev, int arg)
 {
-	wavnc_port_info *portc = (wavnc_port_info *) audio_devs[dev]->portc;
+	struct wavnc_port_info *portc = (struct wavnc_port_info *)
+					audio_devs[dev]->portc;
 
 	if (arg <= 0)
 		return portc->speed;
@@ -782,7 +799,8 @@ waveartist_set_speed(int dev, int arg)
 static short
 waveartist_set_channels(int dev, short arg)
 {
-	wavnc_port_info *portc = (wavnc_port_info *) audio_devs[dev]->portc;
+	struct wavnc_port_info *portc = (struct wavnc_port_info *)
+					audio_devs[dev]->portc;
 
 	if (arg != 1 && arg != 2)
 		return portc->channels;
@@ -794,7 +812,8 @@ waveartist_set_channels(int dev, short arg)
 static unsigned int
 waveartist_set_bits(int dev, unsigned int arg)
 {
-	wavnc_port_info *portc = (wavnc_port_info *) audio_devs[dev]->portc;
+	struct wavnc_port_info *portc = (struct wavnc_port_info *)
+					audio_devs[dev]->portc;
 
 	if (arg == 0)
 		return portc->audio_format;
@@ -829,7 +848,7 @@ static struct audio_driver waveartist_audio_driver = {
 static irqreturn_t
 waveartist_intr(int irq, void *dev_id)
 {
-	wavnc_info *devc = dev_id;
+	struct wavnc_info *devc = dev_id;
 	int	   irqstatus, status;
 
 	spin_lock(&waveartist_lock);
@@ -912,7 +931,7 @@ static const struct mix_ent mix_devs[SOUND_MIXER_NRDEVICES] = {
 };
 
 static void
-waveartist_mixer_update(wavnc_info *devc, int whichDev)
+waveartist_mixer_update(struct wavnc_info *devc, int whichDev)
 {
 	unsigned int lev_left, lev_right;
 
@@ -973,7 +992,8 @@ waveartist_mixer_update(wavnc_info *devc, int whichDev)
  * relevant *_select_input function has done that for us.
  */
 static void
-waveartist_set_adc_mux(wavnc_info *devc, char left_dev, char right_dev)
+waveartist_set_adc_mux(struct wavnc_info *devc, char left_dev,
+		       char right_dev)
 {
 	unsigned int reg_08, reg_09;
 
@@ -996,7 +1016,7 @@ waveartist_set_adc_mux(wavnc_info *devc, char left_dev, char right_dev)
  *  SOUND_MASK_MIC	Mic		Microphone
  */
 static unsigned int
-waveartist_select_input(wavnc_info *devc, unsigned int recmask,
+waveartist_select_input(struct wavnc_info *devc, unsigned int recmask,
 			unsigned char *dev_l, unsigned char *dev_r)
 {
 	unsigned int recdev = ADC_MUX_NONE;
@@ -1024,7 +1044,8 @@ waveartist_select_input(wavnc_info *devc, unsigned int recmask,
 }
 
 static int
-waveartist_decode_mixer(wavnc_info *devc, int dev, unsigned char lev_l,
+waveartist_decode_mixer(struct wavnc_info *devc, int dev,
+			unsigned char lev_l,
 			unsigned char lev_r)
 {
 	switch (dev) {
@@ -1050,7 +1071,7 @@ waveartist_decode_mixer(wavnc_info *devc, int dev, unsigned char lev_l,
 	return dev;
 }
 
-static int waveartist_get_mixer(wavnc_info *devc, int dev)
+static int waveartist_get_mixer(struct wavnc_info *devc, int dev)
 {
 	return devc->levels[dev];
 }
@@ -1068,7 +1089,7 @@ static const struct waveartist_mixer_info waveartist_mixer = {
 };
 
 static void
-waveartist_set_recmask(wavnc_info *devc, unsigned int recmask)
+waveartist_set_recmask(struct wavnc_info *devc, unsigned int recmask)
 {
 	unsigned char dev_l, dev_r;
 
@@ -1092,7 +1113,7 @@ waveartist_set_recmask(wavnc_info *devc, unsigned int recmask)
 }
 
 static int
-waveartist_set_mixer(wavnc_info *devc, int dev, unsigned int level)
+waveartist_set_mixer(struct wavnc_info *devc, int dev, unsigned int level)
 {
 	unsigned int lev_left  = level & 0x00ff;
 	unsigned int lev_right = (level & 0xff00) >> 8;
@@ -1120,7 +1141,7 @@ waveartist_set_mixer(wavnc_info *devc, int dev, unsigned int level)
 static int
 waveartist_mixer_ioctl(int dev, unsigned int cmd, void __user * arg)
 {
-	wavnc_info *devc = (wavnc_info *)audio_devs[dev]->devc;
+	struct wavnc_info *devc = (struct wavnc_info *)audio_devs[dev]->devc;
 	int ret = 0, val, nr;
 
 	/*
@@ -1204,7 +1225,7 @@ static struct mixer_operations waveartist_mixer_operations =
 };
 
 static void
-waveartist_mixer_reset(wavnc_info *devc)
+waveartist_mixer_reset(struct wavnc_info *devc)
 {
 	int i;
 
@@ -1241,9 +1262,9 @@ waveartist_mixer_reset(wavnc_info *devc)
 		waveartist_mixer_update(devc, i);
 }
 
-static int __init waveartist_init(wavnc_info *devc)
+static int __init waveartist_init(struct wavnc_info *devc)
 {
-	wavnc_port_info *portc;
+	struct wavnc_port_info *portc;
 	char rev[3], dev_name[64];
 	int my_dev;
 
@@ -1261,7 +1282,7 @@ static int __init waveartist_init(wavnc_info *devc)
 	conf_printf2(dev_name, devc->hw.io_base, devc->hw.irq,
 		     devc->hw.dma, devc->hw.dma2);
 
-	portc = kzalloc(sizeof(wavnc_port_info), GFP_KERNEL);
+	portc = kzalloc(sizeof(struct wavnc_port_info), GFP_KERNEL);
 	if (portc == NULL)
 		goto nomem;
 
@@ -1330,7 +1351,7 @@ nomem:
 
 static int __init probe_waveartist(struct address_info *hw_config)
 {
-	wavnc_info *devc = &adev_info[nr_waveartist_devs];
+	struct wavnc_info *devc = &adev_info[nr_waveartist_devs];
 
 	if (nr_waveartist_devs >= MAX_AUDIO_DEV) {
 		printk(KERN_WARNING "waveartist: too many audio devices\n");
@@ -1367,7 +1388,7 @@ static int __init probe_waveartist(struct address_info *hw_config)
 static void __init
 attach_waveartist(struct address_info *hw, const struct waveartist_mixer_info *mix)
 {
-	wavnc_info *devc = &adev_info[nr_waveartist_devs];
+	struct wavnc_info *devc = &adev_info[nr_waveartist_devs];
 
 	/*
 	 * NOTE! If irq < 0, there is another driver which has allocated the
@@ -1410,7 +1431,7 @@ attach_waveartist(struct address_info *hw, const struct waveartist_mixer_info *m
 
 static void __exit unload_waveartist(struct address_info *hw)
 {
-	wavnc_info *devc = NULL;
+	struct wavnc_info *devc = NULL;
 	int i;
 
 	for (i = 0; i < nr_waveartist_devs; i++)
@@ -1478,7 +1499,7 @@ static void __exit unload_waveartist(struct address_info *hw)
 #define VNC_DISABLE_AUTOSWITCH	0x80
 
 static inline void
-vnc_mute_spkr(wavnc_info *devc)
+vnc_mute_spkr(struct wavnc_info *devc)
 {
 	unsigned long flags;
 
@@ -1488,7 +1509,7 @@ vnc_mute_spkr(wavnc_info *devc)
 }
 
 static void
-vnc_mute_lout(wavnc_info *devc)
+vnc_mute_lout(struct wavnc_info *devc)
 {
 	unsigned int left, right;
 
@@ -1507,7 +1528,7 @@ vnc_mute_lout(wavnc_info *devc)
 }
 
 static int
-vnc_volume_slider(wavnc_info *devc)
+vnc_volume_slider(struct wavnc_info *devc)
 {
 	static signed int old_slider_volume;
 	unsigned long flags;
@@ -1567,7 +1588,7 @@ vnc_volume_slider(wavnc_info *devc)
  *  SOUND_MASK_MIC	Right Mic	Builtin microphone
  */
 static unsigned int
-netwinder_select_input(wavnc_info *devc, unsigned int recmask,
+netwinder_select_input(struct wavnc_info *devc, unsigned int recmask,
 		       unsigned char *dev_l, unsigned char *dev_r)
 {
 	unsigned int recdev_l = ADC_MUX_NONE, recdev_r = ADC_MUX_NONE;
@@ -1604,7 +1625,7 @@ netwinder_select_input(wavnc_info *devc, unsigned int recmask,
 }
 
 static int
-netwinder_decode_mixer(wavnc_info *devc, int dev, unsigned char lev_l,
+netwinder_decode_mixer(struct wavnc_info *devc, int dev, unsigned char lev_l,
 		       unsigned char lev_r)
 {
 	switch (dev) {
@@ -1643,7 +1664,7 @@ netwinder_decode_mixer(wavnc_info *devc, int dev, unsigned char lev_l,
 	return dev;
 }
 
-static int netwinder_get_mixer(wavnc_info *devc, int dev)
+static int netwinder_get_mixer(struct wavnc_info *devc, int dev)
 {
 	int levels;
 
@@ -1703,7 +1724,7 @@ static const struct waveartist_mixer_info netwinder_mixer = {
 };
 
 static void
-vnc_configure_mixer(wavnc_info *devc, unsigned int recmask)
+vnc_configure_mixer(struct wavnc_info *devc, unsigned int recmask)
 {
 	if (!devc->no_autoselect) {
 		if (devc->handset_detect) {
@@ -1729,7 +1750,7 @@ vnc_configure_mixer(wavnc_info *devc, unsigned int recmask)
 }
 
 static int
-vnc_slider(wavnc_info *devc)
+vnc_slider(struct wavnc_info *devc)
 {
 	signed int slider_volume;
 	unsigned int temp, old_hs, old_td;
@@ -1795,7 +1816,7 @@ vnc_slider_tick(unsigned long data)
 static int
 vnc_private_ioctl(int dev, unsigned int cmd, int __user * arg)
 {
-	wavnc_info *devc = (wavnc_info *)audio_devs[dev]->devc;
+	struct wavnc_info *devc = (struct wavnc_info *)audio_devs[dev]->devc;
 	int val;
 
 	switch (cmd) {
-- 
1.9.1

