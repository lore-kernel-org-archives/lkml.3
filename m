Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaJXWoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:44:55 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35363 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaJXWox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:44:53 -0400
Message-ID: <544AD7CF.5020006@gmail.com>
Date: Sat, 25 Oct 2014 06:50:55 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next] xen: pcifront: Process failure for pcifront_(re)scan_root()
References: <469h2cuyy0a5y5fn77uh3y1b.1413332405802@email.android.com> <20141015210355.GB6579@laptop.dumpdata.com>
In-Reply-To: <20141015210355.GB6579@laptop.dumpdata.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/14 5:03, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 15, 2014 at 08:20:06AM +0800, Chen Gang wrote:
>>
>> At least for me, what you said sound OK.
> 
> Let me review it - next week.

Please help check this patch, when you have time.

Thanks.

>>
>> Thanks.
>>
>>
>> Send from Lenovo A788t.
>>
>> Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>>> On Mon, Oct 06, 2014 at 11:04:45AM +0800, Chen Gang wrote:
>>>> When pcifront_rescan_root() or pcifront_scan_root() fails, need return
>>>> error code, neither set XenbusStateConnected state, just like the other
>>>> areas have done.
>>>>
>>>> For pcifront_rescan_root(), it will return error code ("num_roots = 0;",
>>>> skip xenbus_switch_state return value).
>>>>
>>>> For pcifront_scan_root(), it will return 0 ("num_roots = 0;", set 0 by
>>>> the return value of xenbus_switch_state, which always return 0, at
>>>> present).
>>>
>>> The changelog is somewhat confusing because it talks about the patch hunks
>>> in reverse order (the pcifront_scan_root() change is first in the patch,
>>> but the changelog mentions pcifront_rescan_root() first).  I *think* this
>>> means:
>>>
>>>  When pcifront_try_connect() finds no PCI roots, it falls back to calling
>>>  pcifront_scan_root() for 0000:00.  If that fails, it used to switch to
>>>  XenbusStateConnected and return success (because xenbus_switch_state()
>>>  currently always succeeds).
>>>
>>>  If pcifront_scan_root() fails, leave the XenbusState unchanged and
>>>  return an error code.
>>>
>>>  Similarly, pcifront_attach_devices() falls back to calling
>>>  pcifront_rescan_root() for 0000:00.  If that fails, it used to 
>>>  switch to XenbusStateConnected and return an error code.
>>>
>>>  If pcifront_rescan_root() fails, leave the XenbusState unchanged and
>>>  return the error code.
>>>
>>> The "num_roots" part doesn't seem relevant to me.
>>>
>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>
>>> Konrad, if you want to take this, feel free.  Otherwise, if you ack it and
>>> you think my changelog understanding makes sense, I can pick it up.
>>>
>>> It does seem odd that pcifront_attach_devices() ignores the
>>> xenbus_switch_state() return value while pcifront_try_connect() does not.
>>> But many other callers also ignore the return value, so maybe that's OK.
>>>
>>> Bjorn
>>>
>>>> ---
>>>>  drivers/pci/xen-pcifront.c | 10 ++++++++++
>>>>  1 file changed, 10 insertions(+)
>>>>
>>>> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
>>>> index 53df39a..d78d884 100644
>>>> --- a/drivers/pci/xen-pcifront.c
>>>> +++ b/drivers/pci/xen-pcifront.c
>>>> @@ -866,6 +866,11 @@ static int pcifront_try_connect(struct pcifront_device *pdev)
>>>>  		xenbus_dev_error(pdev->xdev, err,
>>>>  				 "No PCI Roots found, trying 0000:00");
>>>>  		err = pcifront_scan_root(pdev, 0, 0);
>>>> +		if (err) {
>>>> +			xenbus_dev_fatal(pdev->xdev, err,
>>>> +					 "Error scanning PCI root 0000:00");
>>>> +			goto out;
>>>> +		}
>>>>  		num_roots = 0;
>>>>  	} else if (err != 1) {
>>>>  		if (err == 0)
>>>> @@ -947,6 +952,11 @@ static int pcifront_attach_devices(struct pcifront_device *pdev)
>>>>  		xenbus_dev_error(pdev->xdev, err,
>>>>  				 "No PCI Roots found, trying 0000:00");
>>>>  		err = pcifront_rescan_root(pdev, 0, 0);
>>>> +		if (err) {
>>>> +			xenbus_dev_fatal(pdev->xdev, err,
>>>> +					 "Error scanning PCI root 0000:00");
>>>> +			goto out;
>>>> +		}
>>>>  		num_roots = 0;
>>>>  	} else if (err != 1) {
>>>>  		if (err == 0)
>>>> -- 
>>>> 1.9.3

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
