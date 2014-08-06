Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbaHFT0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:26:06 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:60804 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037AbaHFT0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:26:04 -0400
Date: Wed, 6 Aug 2014 21:25:59 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1081188855.20140806212559@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: gregkh@linuxfoundation.org, boris.ostrovsky@oracle.com,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v5] Fixes to Xen pciback for 3.17.
In-Reply-To: <20140806191831.GB30062@laptop.dumpdata.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com> <53DBB27D.2040203@citrix.com> <20140804184318.GB9009@laptop.dumpdata.com> <75613802.20140805104438@eikelenboom.it> <53E0A45C.4050400@citrix.com> <1985206568.20140805114433@eikelenboom.it> <20140805134930.GE13057@laptop.dumpdata.com> <1724263917.20140805160443@eikelenboom.it> <182103485.20140806205959@eikelenboom.it> <20140806191831.GB30062@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wednesday, August 6, 2014, 9:18:31 PM, you wrote:

> On Wed, Aug 06, 2014 at 08:59:59PM +0200, Sander Eikelenboom wrote:
>> 
>> Tuesday, August 5, 2014, 4:04:43 PM, you wrote:
>> 
>> 
>> > Tuesday, August 5, 2014, 3:49:30 PM, you wrote:
>> 
>> >> On Tue, Aug 05, 2014 at 11:44:33AM +0200, Sander Eikelenboom wrote:
>> >>> 
>> >>> Tuesday, August 5, 2014, 11:31:08 AM, you wrote:
>> >>> 
>> >>> > On 05/08/14 09:44, Sander Eikelenboom wrote:
>> >>> >> 
>> >>> >> Monday, August 4, 2014, 8:43:18 PM, you wrote:
>> >>> >> 
>> >>> >>> On Fri, Aug 01, 2014 at 04:30:05PM +0100, David Vrabel wrote:
>> >>> >>>> On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
>> >>> >>>>> Greg: goto GHK
>> >>> >>>>>
>> >>> >>>>> This is v5 version of patches to fix some issues in Xen PCIback.
>> >>> >>>>
>> >>> >>>> Applied to devel/for-linus-3.17.
>> >>> >> 
>> >>> >>> Thank you.
>> >>> >>>>
>> >>> >>>> I dropped the stable Cc for #2 pending a final decision on whether it
>> >>> >>>> really is a stable candidate.
>> >>> >> 
>> >>> >>> OK.
>> >>> >>>>
>> >>> >>>> David
>> >>> >> 
>> >>> >> Hi Konrad / David,
>> >>> >> 
>> >>> >> This series still lacks a resolution on the sysfs /do_flr /reset,
>> >>> >> as a result the pci devices are not reset after shutdown of a guest.
>> >>> >> (no more pciback 0000:xx:xx.x: restoring config space at offset xxx)
>> >>> >> 
>> >>> >> So this series now introduces a regression to 3.16, which causes devices to malfunction 
>> >>> >> after a guest reboot or after assigning the devices to another guest.
>> >>> 
>> >>> > I don't follow what you're saying.  The lack of a device reset for PCI
>> >>> > devices with no FLR method isn't a regression as this has never worked.
>> >>> >  Can you explain in more detail what the regression is and which patch
>> >>> > caused it?
>> >>> 
>> >>> I haven't bisected it to a specific patch in this series,
>> >>> but this patch series (when pulled on top of 3.16) cause the following:
>> >>> 
>> >>> - Do a system start and HVM guest start
>> >>> - HVM guest with pci passthrough, devices work fine
>> >>> - shutdown the HVM guest
>> >>> - "pciback 0000:xx:xx.x: restoring config space at offset xxx" messages do not
>> >>>   appear anymore when shutting down the HVM guest (as they do with vanilla 3.16)
>> >>> - Starting the HVM guest again with the same devices passed through.
>> >>> - Devices malfunction (for example a USB host controller will fail a simple 
>> >>>   "lsusb"
>> >>> - And this all works fine on vanilla 3.16.  
>> 
>> >> Hm, the only patch that makes code changes is 63fc5ec97cc54257d1c4ee49ed2131f754a5ff9b
>> >> "xen/pciback: Don't deadlock when unbinding."
>> >> but it does not change any of that code path. Only figures out whether
>> >> to take a lock or not.
>> 
>> > Ok and the do_flr nack by david is unrelated to this part (i didn't check just 
>> > assumed there could be a connection)
>> 
>> >> I will try it out on my box and see if I can reproduce it.
>> 
>> >> And just to be 100% sure - you are using vanilla Xen? No changes on top
>> >> of it?
>> 
>> > Except the fix from jan for the pirq/msi stuff (and an unrelated hpet one), other than that no.
>> > If you can't reproduce i will see if i can dive deeper into it tonight !
>> 
>> Hi Konrad,
>> 
>> It looks like the issues is this part of the change:
>> 
>>     --- a/drivers/xen/xen-pciback/pci_stub.c
>>     +++ b/drivers/xen/xen-pciback/pci_stub.c
>>     @@ -250,6 +250,8 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
>>     * - 'echo BDF > unbind' with a guest still using it. See pcistub_remove
>>     *
>>     * As such we have to be careful.
>>     + *
>>     + * To make this easier, the caller has to hold the device lock.
>>     */
>>     void pcistub_put_pci_dev(struct pci_dev *dev)
>>     {
>>     @@ -276,11 +278,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>>     /* Cleanup our device
>>     * (so it's ready for the next domain)
>>     */
>>     -
>>     - /* This is OK - we are running from workqueue context
>>     - * and want to inhibit the user from fiddling with 'reset'
>>     - */
>>     - pci_reset_function(dev);
>>     + lockdep_assert_held(&dev->dev.mutex);
>>     + __pci_reset_function_locked(dev);
>>     pci_restore_state(dev);
>>    /* This disables the device. */
>> 
>> More specifically:
>> The old "pci_reset_function(dev)" potentially seems to do much more than 
>> __pci_reset_function_locked(dev).
>> 
>> 
>> "__pci_reset_function_locked(dev)" only calls  "__pci_dev_reset"
>> while "pci_reset_function" not only calls pci_dev_reset, but on succes
>> it also calls: "pci_dev_save_and_disable" which does a save state etc.
>> 
>> 
>> So i added a little more debug:
>> 
>> device_lock_assert(&dev->dev);
>> ret = __pci_reset_function_locked(dev);
>> dev_dbg(&dev->dev, "%s __pci_reset_function_locked:%d  dev->state_saved:%d\n", __func__, ret, (!dev->state_saved) ? 0 : 1 );
>> pci_restore_state(dev);
>> 
>> And this returns:
>> [  494.570579] pciback 0000:04:00.0: pcistub_put_pci_dev __pci_reset_function_locked:0  dev->state_saved:0
>> 
>> So that confirms there is no saved_state to get restored by 
>> pci_restore_state(dev) in the next line.
>> 
>> However there seems to be no "locked" variant of the function 
>> "pci_reset_function" in pci.c that has all the same logic ...

> Yup. I've a preliminary patch:

Preliminary in the sense: "this should fix it .. needs more testing" ?

> diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
> index 1ddd22f..4cb7901 100644
> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -105,7 +105,7 @@ static void pcistub_device_release(struct kref *kref)
>          */
>         __pci_reset_function_locked(dev);
>         if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
> -               dev_dbg(&dev->dev, "Could not reload PCI state\n");
> +               dev_info(&dev->dev, "Could not reload PCI state\n");
>         else
>                 pci_restore_state(dev);
>  
> @@ -257,6 +257,7 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>  {
>         struct pcistub_device *psdev, *found_psdev = NULL;
>         unsigned long flags;
> +       struct xen_pcibk_dev_data *dev_data;
>  
>         spin_lock_irqsave(&pcistub_devices_lock, flags);
>  
> @@ -278,10 +279,25 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>         /* Cleanup our device
>          * (so it's ready for the next domain)
>          */
> -       device_lock_assert(&dev->dev);
> -       __pci_reset_function_locked(dev);
> -       pci_restore_state(dev);
> -
> +       if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
> +               dev_info(&dev->dev, "Could not reload PCI state\n");
> +       else {
> +               device_lock_assert(&dev->dev);
> +               __pci_reset_function_locked(dev);
> +               /*
> +                * The usual sequence is pci_save_state & pci_restore_state
> +                * but the guest might have messed the config space up. Use
> +                * the initial configuration (when device was binded to us).
> +                */
> +               pci_restore_state(dev);
> +               /*
> +                * The next steps are to reload the configuration for the
> +                * next time we need to unbind/bind to a guest..
> +                */
> +               dev_data = pci_get_drvdata(dev);
> +               pci_save_state(dev);
> +               dev_data->pci_saved_state = pci_store_saved_state(dev);
> +       }
>         /* This disables the device. */
>         xen_pcibk_reset_device(dev);
>  
>> 
>> --
>> Sander 
>> 
>> >> Thanks!
>> 
>> >>> 
>> >>> >> Apart from that .. i can't resist to remind the other issue with removing pci
>> >>> >> devices passed through to HVM guests related to the signaling via xenstore,
>> >>> >> described in:
>> >>> >> 
>> >>> >> http://lists.xen.org/archives/html/xen-devel/2014-07/msg01875.html
>> >>> 
>> >>> > I don't remember seeing you posting a patch...?
>> 
>> >> I was going to, but I think we need to figure out the 'do_flr' mechanism
>> >> first.
>> 
>> >>> 
>> >>> > David
>> >>> 
>> >>> 
>> 
>> 
>> 
>> 
>> 


