Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbaEGNhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:37:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:16929 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933215AbaEGNhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:37:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1003,1389772800"; 
   d="scan'208";a="428870219"
Message-ID: <536A39C0.5060205@linux.intel.com>
Date: Wed, 07 May 2014 16:48:48 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
        Julius Werner <jwerner@chromium.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression 3.15-rc3] Resume from s4 broken by 1f81b6d22a5980955b01e08cf27fb745dc9b686f
References: <20140505180530.GA18465@intel.com> <CAODwPW_57G+Lebe2Xarem9P-L6ePtAaZfy5kpNVEtgkWbc0FWw@mail.gmail.com> <20140506114126.GB18465@intel.com>
In-Reply-To: <20140506114126.GB18465@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 02:41 PM, Ville Syrjälä wrote:
> On Mon, May 05, 2014 at 12:32:22PM -0700, Julius Werner wrote:
>> Hmmm... very odd. I unfortunately don't have a machine that can easily
>> do S4 at hand, but I did test this on an IVB with XHCI_RESET_ON_RESUME
>> in S3 (essentially the same code path), and I didn't run into any
>> problems.
>>
>> How exactly does your machine fail on resume? Is it a kernel crash or
>> just a hang? Can you try getting some debug output (by setting 'echo N
>>> /sys/module/printk/parameters/console_suspend' and trying to catch
>> the crash on the screen or a serial line, or maybe through pstore)? I
>> really don't see much that could go wrong with this patch, so without
>> more info it will be hard to understand your problem.
>>
>> Also, I noticed that you have two HID devices plugged in during
>> suspend. Does it make a difference if you have different devices (e.g.
>> a mass storage stick) or none at all?
>
> Looks like it doesn't like it when there's anything plugged into the
> "SS" ports. I tried with just a HID keyboard or with just a hub. In
> both cases it fails to resume. If I have nothing connected to the "SS"
> ports then it resumes just fine.
>
> I managed to catch something with ramoops. Looks like it's hitting
> POISON_FREE when trying to delete some list entry.
>

> <4>[  107.047230] xhci_hcd 0000:00:14.0: Slot 1 endpoint 2 not removed from BW list!
> <4>[  107.047574] general protection fault: 0000 [#1] PREEMPT SMP

I took a look at the xhci_mem_cleanup() function and to me it looks
like it tries to access a list_head that is already freed.

The struct list_head xhci->devs[].eps[].bw_endpoint_list is added to an endpoint 
list in xhci->rh_bw[].bw_table.interval_bw[].endpoints

xhci_mem_cleanup() frees all devices (the allocated xhci->devs[], containing the 
bw_endpoint_list) before it starts to loop through, and delete entries from the 
xhci->rh_bw[].bw_table.interval_bw[].endpoints list.

I can't see how this relates to Julius patch though, and I'm not sure yet why it 
only triggers when devices are connected to SS ports. Maybe just unlucky timing?

Does this help?:

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index c089668..b1a8a5f 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1822,6 +1822,16 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
                 kfree(cur_cd);
         }

+       num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
+       for (i = 0; i < num_ports; i++) {
+               struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
+               for (j = 0; j < XHCI_MAX_INTERVAL; j++) {
+                       struct list_head *ep = &bwt->interval_bw[j].endpoints;
+                       while (!list_empty(ep))
+                               list_del_init(ep->next);
+               }
+       }
+
         for (i = 1; i < MAX_HC_SLOTS; ++i)
                 xhci_free_virt_device(xhci, i);

@@ -1857,16 +1867,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
         if (!xhci->rh_bw)
                 goto no_bw;

-       num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
-       for (i = 0; i < num_ports; i++) {
-               struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
-               for (j = 0; j < XHCI_MAX_INTERVAL; j++) {
-                       struct list_head *ep = &bwt->interval_bw[j].endpoints;
-                       while (!list_empty(ep))
-                               list_del_init(ep->next);
-               }
-       }
-
         for (i = 0; i < num_ports; i++) {
                 struct xhci_tt_bw_info *tt, *n;
                 list_for_each_entry_safe(tt, n, &xhci->rh_bw[i].tts, tt_list) {
