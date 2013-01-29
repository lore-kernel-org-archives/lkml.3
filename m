Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3A2AcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:32:08 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:37709 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3A2AcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:32:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5Cfi0KbOqDr4TfnzjWFy7V-oi0bOY-vf8Y16_RPtEGdQ@mail.gmail.com>
References: <20130118113019.6698.25941.stgit@zurg> <20130118114218.6698.42484.stgit@zurg>
 <CAErSpo5Cfi0KbOqDr4TfnzjWFy7V-oi0bOY-vf8Y16_RPtEGdQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Jan 2013 17:31:44 -0700
Message-ID: <CAErSpo7g7H8QM4Rgc05ORM1xHPxVf74KX2G61mvMtMF+N=qh5Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] e1000e: fix pci device enable counter balance
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael @sisk.pl]

On Mon, Jan 28, 2013 at 4:09 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Rafael]
>
> On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
> <khlebnikov@openvz.org> wrote:
>> __e1000_shutdown() calls pci_disable_device() at the end, thus __e1000_resume()
>> should call pci_enable_device_mem() to keep enable counter in balance.
>>
>> Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
>> ("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
>> Cc: e1000-devel@lists.sourceforge.net
>> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> Cc: Bruce Allan <bruce.w.allan@intel.com>
>> ---
>>  drivers/net/ethernet/intel/e1000e/netdev.c |    7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>> index 2853c11..6bce796 100644
>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>> @@ -5598,6 +5598,13 @@ static int __e1000_resume(struct pci_dev *pdev)
>>         pci_restore_state(pdev);
>>         pci_save_state(pdev);
>>
>> +       err = pci_enable_device_mem(pdev);
>> +       if (err) {
>> +               dev_err(&pdev->dev,
>> +                       "Cannot re-enable PCI device after suspend.\n");
>> +               return err;
>> +       }
>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
>
> Seems right to me, and the other users I looked at (igb, azx,
> virtio_pci) call pci_disable_device() in .suspend() and call
> pci_enable_device() in .resume() as you propose to do here.
>
> I assume the e1000 folks will handle this patch (and the previous one).
>
>> +
>>         e1000e_set_interrupt_capability(adapter);
>>         if (netif_running(netdev)) {
>>                 err = e1000_request_irq(adapter);
>>

I'm still missing something.  In your original report
(https://lkml.org/lkml/2013/1/1/25), you noticed that "enable_cnt ==
0" immediately after boot, after e1000e had claimed the device:

> Right after boot it looks like this:
>
> root@zurg:/sys/bus/pci/devices# lspci
> ...
> 00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network Connection (rev 04)
> ...
> root@zurg:/sys/bus/pci/devices# cat 0000\:00\:19.0/enable
> 0
> here must be '1', not '0'

But these patches only change the e1000e suspend/resume path.  How
could they change the enable_cnt before you've even done a suspend?

Bjorn
