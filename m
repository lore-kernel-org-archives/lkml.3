Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab3FRQeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:34:04 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34506 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132Ab3FRQdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:33:52 -0400
Message-ID: <51C08BEA.1030804@gmail.com>
Date: Wed, 19 Jun 2013 00:33:46 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH v3, part2 15/20] PCI, EDAC: use hotplug-safe PCI bus iterators
 to walk PCI buses
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com> <1369583597-3801-16-git-send-email-jiang.liu@huawei.com> <20130617201802.GB7877@google.com>
In-Reply-To: <20130617201802.GB7877@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 04:18 AM, Bjorn Helgaas wrote:
> On Sun, May 26, 2013 at 11:53:12PM +0800, Jiang Liu wrote:
>> Enhance EDAC drviers to use hotplug-safe iterators to walk PCI buses.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Doug Thompson <dougthompson@xmission.com> r
>> Cc: linux-edac@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  drivers/edac/i7core_edac.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
>> index 0ec3e95..7146e10 100644
>> --- a/drivers/edac/i7core_edac.c
>> +++ b/drivers/edac/i7core_edac.c
>> @@ -1296,7 +1296,7 @@ static unsigned i7core_pci_lastbus(void)
>>  	int last_bus = 0, bus;
>>  	struct pci_bus *b = NULL;
>>  
>> -	while ((b = pci_find_next_bus(b)) != NULL) {
>> +	for_each_pci_root_bus(b) {
> 
> This doesn't look equivalent.  Previously, we iterated over all PCI
> buses, so we returned the highest bus number seen anywhere.  Now we
> only look at root buses, so we return the highest bus number of any
> root bus.  But if that root bus has a bridge on it, obviously the
> bus on the other side has a higher number.
Hi Bjorn,
	I think the name pci_find_next_bus() is misleading, it should be named
pci_find_next_root_bus() actually because it returns next root bus indeed.

> 
> Even with that fix, a hot-add at the same time i7core_probe() runs
> could mean an incorrect result.  This is all very i7 topology-dependent,
> so I don't think the PCI core can do anything more than avoid oopses
> from traversing lists incorrectly.
Yeah, it's very architecture specific. I think i7core_edac assume no PCI
root bus hotplug on i7 platforms because it's desktop or mobile processors.

> 
> Bjorn
> 
>>  		bus = b->number;
>>  		edac_dbg(0, "Found bus %d\n", bus);
>>  		if (bus > last_bus)
>> -- 
>> 1.8.1.2
>>

