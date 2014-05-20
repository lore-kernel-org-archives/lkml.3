Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaETXi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:38:29 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34926 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaETXi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:38:27 -0400
Date: Tue, 20 May 2014 16:38:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Francesco Ruggeri <fruggeri@arista.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Francesco Ruggeri <fruggeri@aristanetworks.com>
Subject: Re: pci: kernel crash in bus_find_device
Message-ID: <20140520233812.GA15640@roeck-us.net>
References: <CA+HUmGjvHgWB3vcPnXAEVFdFuy9sOaB1BjaDW1-7ai933XEGWQ@mail.gmail.com>
 <20140520195041.GA28913@roeck-us.net>
 <CA+HUmGg4mE5RDxShNCK78yLi9gdX_FnHtWPKfGD4LaEqrCdj2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HUmGg4mE5RDxShNCK78yLi9gdX_FnHtWPKfGD4LaEqrCdj2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 03:35:15PM -0700, Francesco Ruggeri wrote:
> Hi Guenter,
> thank you for your reply. I will check out the changes that you pointed to.
> The problem we are seeing is a race condition between for_each_pci_dev
> (or similar) and device_unregisters. I am not sure if use of the new
> lock should be extended to all code using for_each_pci_dev as well.
> 
> pci_scan is a kernel thread that I used for testing purposes, to
> mimick the dynamics that we saw in our crashes in
> edac_pci_clear_parity_errors:
> 
>         for (;;) {
>                 pci_dev = NULL;
>                 while ((pci_dev = pci_get_device(PCI_ANY_ID,
> PCI_ANY_ID, pci_dev)) != NULL)
>                         ;
>         }
> 
> It keeps traversing klist_devices in pci_bus_type using
> bus_find_device, costantly resuming its search for the next element
> starting from the one it got in the previous round.
> There are several loops of this kind in linux. In case of this thread
> no action is taken on the elements as they are "found".
> 
> The race condition occurs when bus_find_device resumes its search from
> a device that has been unregistered. Because device_unregister resets
> klist_bus in the device, bus_find device cannot resume from where it
> left off in the klist.
> The sequence is device_unregister, device_del, bus_remove_device,
> klist_del(&dev->p->knode_bus.).
> 
Hmmm ... sounds more like a generic problem, not specifically related to pci.
Essentially everything calling bus_find_device() with a starting device which
has been removed (though only pci and scsi seem to be doing that in practice).

Can you reproduce the problem with the latest kernel ? Also, can you
send me the entire file with the kernel thread you mentioned above ?
Maybe I can reproduce the problem here.

Thanks,
Guenter
