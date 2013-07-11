Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3GKIvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:51:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41460 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab3GKIvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:51:32 -0400
Message-ID: <51DE71F3.1040101@ti.com>
Date: Thu, 11 Jul 2013 11:50:59 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] USB: ehci-omap: Implement suspend/resume
References: <Pine.LNX.4.44L0.1307101446270.1215-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1307101446270.1215-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 10:04 PM, Alan Stern wrote:
> On Wed, 10 Jul 2013, Roger Quadros wrote:
> 
>> Call ehci_suspend/resume() during runtime suspend/resume
>> as well as system suspend/resume.
>>
>> Use a flag "bound" to indicate that the HCD structures are valid.
>> This is only true between usb_add_hcd() and usb_remove_hcd() calls.
>>
>> The flag can be used by omap_ehci_runtime_suspend/resume() handlers
>> to avoid calling ehci_suspend/resume() when we are no longer bound
>> to the HCD e.g. during probe() and remove();
> 
>> @@ -293,15 +301,67 @@ static const struct of_device_id omap_ehci_dt_ids[] = {
>>  
>>  MODULE_DEVICE_TABLE(of, omap_ehci_dt_ids);
>>  
>> +static int omap_ehci_suspend(struct device *dev)
>> +{
>> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
>> +
>> +	dev_dbg(dev, "%s\n", __func__);
>> +
>> +	return ehci_suspend(hcd, true);
>> +}
>> +
>> +static int omap_ehci_resume(struct device *dev)
>> +{
>> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
>> +
>> +	dev_dbg(dev, "%s\n", __func__);
>> +
>> +	return ehci_resume(hcd, false);
>> +}
> 
> There are three problems here.  The first is very simple: the wakeup 
> settings are messed up.  Wakeup is supposed to be enabled always for
> runtime suspend, whereas it is controlled by device_may_wakeup() for
> system suspend.  You reversed them.

Indeed. I'll fix that up.

However, even if wakeup is disabled during system suspend, the OMAP will
still wakeup on any activity on the USB pins.

The only way to disable that is to disable IO pad wakeup. This can
only be done in mfd/omap-usb-host.c

I suppose I can use device_may_wakeup() there and configure the IO pad
wakeup accordingly.

> 
> The other two problems are both related to the interaction between
> system PM and runtime PM.  Suppose the controller is already runtime
> suspended when the system goes to sleep.  Because it is runtime
> suspended, it is enabled for wakeup.  But device_may_wakeup() could
> return false; if this happens then you have to do a runtime-resume in
> omap_ehci_suspend() before calling ehci_suspend(), so that the
> controller can be suspended again with wakeups disabled.  (Or you could
> choose an alternative method for accomplishing the same result, such as
> disabling the wakeup signal from the pad without going through a whole
> EHCI resume/suspend cycle.)  Conversely, if device_may_wakeup() returns
> true then you shouldn't do anything at all, because the controller is
> already suspended with the correct wakeup setting.

I think this case is taken care of by the Runtime PM core at least for the OMAP
platform according to the documentation

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/power/runtime_pm.txt#n647

At the end of this mail is the log during system suspend/resume

You can notice the following sequence

-ehci runtime suspends
-system suspend triggered
-ehci runtime resumes
-ehci suspends (uses new wakeup settings)
-system wakeup triggered
-ehci resumes
-ehci runtime suspends

> 
> For the third problem, suppose the controller was runtime suspended
> when the system went to sleep.  When the system wakes up, the
> controller will become active, so you have to inform the runtime PM
> core about its change of state.  Basically, if omap_ehci_resume() sees
> that ehci_resume() returned 0 then it must do:
> 
> 	pm_runtime_disable(dev);
> 	pm_runtime_set_active(dev);
> 	pm_runtime_enable(dev);
> 
> All of these issues are discussed (among lots of other material) in 
> Documentation/power/runtime_pm.txt.

Is this still applicable? Documentation claims

   "During system resume it calls pm_runtime_enable() and pm_runtime_put_sync()
    for every device right after executing the subsystem-level .resume_early()
    callback and right after executing the subsystem-level .resume() callback
    for it, respectively."

cheers,
-roger

---
[   13.256286] smsc95xx 1-2.1:1.0 eth0: entering SUSPEND2 mode
[   13.264648] usb 1-2.1: usb auto-suspend, wakeup 0
[   13.281677] hub 1-2:1.0: hub_suspend
[   13.285858] usb 1-2: unlink qh256-0001/dd443880 start 1 [1/0 us]
/
/ # [   13.296386] usb 1-2: usb auto-suspend, wakeup 1
[   13.321411] hub 1-0:1.0: hub_suspend
[   13.325225] usb usb1: bus auto-suspend, wakeup 1
[   13.330139] ehci-omap 48064800.ehci: suspend root hub
[   13.336395] ehci-omap 48064800.ehci: omap_ehci_runtime_suspend

/ # 
/ # echo mem > /sys/power/state 
[   26.821838] PM: Syncing filesystems ... done.
[   26.828491] PM: Preparing system for mem sleep
[   26.841796] Freezing user space processes ... (elapsed 0.000 seconds) done.
[   26.849426] Freezing remaining freezable tasks ... (elapsed 0.002 seconds) done.
[   26.860046] PM: Entering mem sleep
[   26.863769] Suspending console(s) (use no_console_suspend to debug)
[   26.878234] ehci-omap 48064800.ehci: omap_ehci_runtime_resume
[   26.878295] usb usb1: usb auto-resume
[   26.878326] ehci-omap 48064800.ehci: resume root hub
[   26.878417] hub 1-0:1.0: hub_resume
[   26.878570] hub 1-0:1.0: port 2: status 0507 change 0000
[   26.879089] hub 1-0:1.0: hub_suspend
[   26.879211] usb usb1: bus suspend, wakeup 0
[   26.879241] ehci-omap 48064800.ehci: suspend root hub
[   26.891845] ehci-omap 48064800.ehci: omap_ehci_suspend may_wakeup 0
[   26.923797] PM: suspend of devices complete after 47.912 msecs
[   26.929443] PM: late suspend of devices complete after 5.645 msecs
[   26.935882] PM: noirq suspend of devices complete after 6.378 msecs
[   26.935943] Disabling non-boot CPUs ...
[   26.936065] Successfully put all powerdomains to target state
[   26.939636] PM: noirq resume of devices complete after 3.448 msecs
[   26.945190] PM: early resume of devices complete after 4.180 msecs
[   26.954833] ehci-omap 48064800.ehci: omap_ehci_resume
[   26.955383] usb usb1: usb resume
[   26.955383] ehci-omap 48064800.ehci: resume root hub
[   26.955413] hub 1-0:1.0: hub_resume
[   26.955535] hub 1-0:1.0: port 2: status 0507 change 0000
[   26.955902] usb 1-2: usb resume
[   26.990661] ehci-omap 48064800.ehci: GetStatus port:2 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   27.010528] usb 1-2: finish resume
[   27.010894] hub 1-2:1.0: hub_resume
[   27.011352] hub 1-2:1.0: port 1: status 0507 change 0000
[   27.012390] ehci-omap 48064800.ehci: reused qh dd443880 schedule
[   27.012390] usb 1-2: link qh256-0001/dd443880 start 1 [1/0 us]
[   27.013244] usb 1-2.1: usb resume
[   27.070800] usb 1-2.1: finish resume
[   27.072998] PM: resume of devices complete after 127.716 msecs
[   27.243438] PM: Finishing wakeup.
[   27.246948] Restarting tasks ... [   27.251312] hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0000
[   27.257171] hub 1-2:1.0: state 7 ports 5 chg 0000 evt 0000
done.
/ # [   29.074493] smsc95xx 1-2.1:1.0 eth0: entering SUSPEND2 mode
[   29.082458] usb 1-2.1: usb auto-suspend, wakeup 0
[   29.100891] hub 1-2:1.0: hub_suspend
[   29.104736] usb 1-2: unlink qh256-0001/dd443880 start 1 [1/0 us]
[   29.114288] usb 1-2: usb auto-suspend, wakeup 1
[   29.130859] hub 1-0:1.0: hub_suspend
[   29.134735] usb usb1: bus auto-suspend, wakeup 1
[   29.139648] ehci-omap 48064800.ehci: suspend root hub
[   29.145446] ehci-omap 48064800.ehci: omap_ehci_runtime_suspend

