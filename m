Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaBLPH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:07:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42703 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaBLPHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:07:54 -0500
Date: Wed, 12 Feb 2014 16:07:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: linux-edac@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac, poll timeout cannot be zero
Message-ID: <20140212150748.GE5121@pd.tnic>
References: <1391457913-881-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1391457913-881-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 03:05:13PM -0500, Prarit Bhargava wrote:
> If you do
> 
> echo 0 > /sys/module/edac_core/parameters/edac_mc_poll_msec
> 
> the following stack trace is output because the edac module is not
> designed to poll with a timeout of zero.

Ok, I took your patch and extended it a bit, see bottom of mail. We're
not allowing intervals lower than a second now because it doesn't make
any sense, IMO.

While testing, however, I keep seeing the splat below and that's:

        if (WARN_ON(!list_empty(&work->entry))) {
                spin_unlock(&pwq->pool->lock);
                return;
        }

and there seems to be some interference with edac_mc_workq_setup()
which does mod_delayed_work() and then the workqueue callback
edac_mc_workq_function() which does queue_delayed_work().

What I'm seeing in the splat is that when the timer fires to run the
delayed work, __queue_work() complains that the work list is not empty
even though we've done mod_delayed_work() which is supposed to cancel
any pending work.

Tejun, any ideas what's happening? Do we need synchronization here or do
you have a _sync version of mod_delayed_work() which makes sure any work
is cancelled?

Or does this mean that once the work is getting queued from the timer
callback delayed_work_timer_fn, it cannot be cancelled anymore? Or
something else I'm missing...?

Thanks.

[ 4143.086470] ------------[ cut here ]------------
[ 4143.094342] WARNING: CPU: 1 PID: 0 at kernel/workqueue.c:1393 __queue_work+0x1d7/0x340()
[ 4143.105683] Modules linked in: sb_edac edac_core ext2 vfat fat fuse loop dm_crypt dm_mod usbhid x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel ehci_pci aesni_intel ehci_hcd aes_x86_64 xhci_hcd glue_helper snd_hda_codec_hdmi lrw usbcore gf128mul ablk_helper cryptd snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec microcode snd_hwdep snd_pcm iTCO_wdt snd_timer pcspkr iTCO_vendor_support evdev i2c_i801 lpc_ich usb_common button snd dcdbas mfd_core acpi_cpufreq soundcore processor [last unloaded: edac_core]
[ 4143.167227] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc2+ #3
[ 4143.177066] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[ 4143.187959]  0000000000000009 ffff88044ec43da8 ffffffff8163a5e0 0000000000000000
[ 4143.198898]  ffff88044ec43de0 ffffffff8104ae9d ffff88043a866100 ffff8804338b6428
[ 4143.209844]  0000000000000008 ffff88043a39f200 000000000000f128 ffff88044ec43df0
[ 4143.220808] Call Trace:
[ 4143.226686]  <IRQ>  [<ffffffff8163a5e0>] dump_stack+0x4d/0x66
[ 4143.235942]  [<ffffffff8104ae9d>] warn_slowpath_common+0x7d/0xa0
[ 4143.245407]  [<ffffffff8104af7a>] warn_slowpath_null+0x1a/0x20
[ 4143.254662]  [<ffffffff81066707>] __queue_work+0x1d7/0x340
[ 4143.263546]  [<ffffffff81066ed0>] ? execute_in_process_context+0xa0/0xa0
[ 4143.273625]  [<ffffffff81066eee>] delayed_work_timer_fn+0x1e/0x20
[ 4143.283091]  [<ffffffff81056cef>] call_timer_fn+0x7f/0x180
[ 4143.291939]  [<ffffffff81056c75>] ? call_timer_fn+0x5/0x180
[ 4143.300833]  [<ffffffff81066ed0>] ? execute_in_process_context+0xa0/0xa0
[ 4143.310866]  [<ffffffff81056f52>] run_timer_softirq+0x162/0x2b0
[ 4143.320117]  [<ffffffff810503ae>] __do_softirq+0x12e/0x300
[ 4143.328889]  [<ffffffff81050835>] irq_exit+0xa5/0xb0
[ 4143.337114]  [<ffffffff8164d925>] smp_apic_timer_interrupt+0x45/0x60
[ 4143.346711]  [<ffffffff8164c6ef>] apic_timer_interrupt+0x6f/0x80
[ 4143.355944]  <EOI>  [<ffffffff815202a4>] ? cpuidle_enter_state+0x54/0xc0
[ 4143.365927]  [<ffffffff815203d2>] cpuidle_idle_call+0xc2/0x220
[ 4143.374979]  [<ffffffff8100c00e>] arch_cpu_idle+0xe/0x30
[ 4143.383499]  [<ffffffff810a655a>] cpu_startup_entry+0xea/0x2c0
[ 4143.392524]  [<ffffffff8102f946>] start_secondary+0x1e6/0x240
[ 4143.401423] ---[ end trace a140660262786ef9 ]---

---
From: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] EDAC: Poll timeout cannot be zero

Filter out 0 as it is an invalid poll timeout.

Boris: sanitize code even more to accept unsigned longs only and to
not allow polling intervals below 1 second as this is unnecessary and
doesn't make much sense for polling errors.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1391457913-881-1-git-send-email-prarit@redhat.com
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: stable@vger.kernel.org
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/edac_mc.c       |  4 ++--
 drivers/edac/edac_mc_sysfs.c | 10 ++++++----
 drivers/edac/edac_module.h   |  2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index e8c9ef03495b..aef5ec24908e 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -601,7 +601,7 @@ static void edac_mc_workq_teardown(struct mem_ctl_info *mci)
  *	user space has updated our poll period value, need to
  *	reset our workq delays
  */
-void edac_mc_reset_delay_period(int value)
+void edac_mc_reset_delay_period(unsigned long value)
 {
 	struct mem_ctl_info *mci;
 	struct list_head *item;
@@ -611,7 +611,7 @@ void edac_mc_reset_delay_period(int value)
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
 
-		edac_mc_workq_setup(mci, (unsigned long) value);
+		edac_mc_workq_setup(mci, value);
 	}
 
 	mutex_unlock(&mem_ctls_mutex);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 51c0362acf5c..b335c6ab5efe 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -52,18 +52,20 @@ int edac_mc_get_poll_msec(void)
 
 static int edac_set_poll_msec(const char *val, struct kernel_param *kp)
 {
-	long l;
+	unsigned long l;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
 
-	ret = kstrtol(val, 0, &l);
+	ret = kstrtoul(val, 0, &l);
 	if (ret)
 		return ret;
-	if ((int)l != l)
+
+	if (l < 1000)
 		return -EINVAL;
-	*((int *)kp->arg) = l;
+
+	*((unsigned long *)kp->arg) = l;
 
 	/* notify edac_mc engine to reset the poll period */
 	edac_mc_reset_delay_period(l);
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 3d139c6e7fe3..f2118bfcf8df 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -52,7 +52,7 @@ extern void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
 extern void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
-extern void edac_mc_reset_delay_period(int value);
+extern void edac_mc_reset_delay_period(unsigned long value);
 
 extern void *edac_align_ptr(void **p, unsigned size, int n_elems);
 
-- 
1.8.5.2.192.g7794a68

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
