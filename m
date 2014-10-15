Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaJOAUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 20:20:17 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61641 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaJOAUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 20:20:15 -0400
Date: Wed, 15 Oct 2014 08:20:06 +0800
Subject: Re: [PATCH next] xen: pcifront: Process failure for
 pcifront_(re)scan_root()
Message-ID: <469h2cuyy0a5y5fn77uh3y1b.1413332405802@email.android.com>
From: Chen Gang <gang.chen.5i5j@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org,
        " linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9F0KQWJ027893


At least for me, what you said sound OK.

Thanks.


Send from Lenovo A788t.

Bjorn Helgaas <bhelgaas@google.com> wrote:

>On Mon, Oct 06, 2014 at 11:04:45AM +0800, Chen Gang wrote:
>> When pcifront_rescan_root() or pcifront_scan_root() fails, need return
>> error code, neither set XenbusStateConnected state, just like the other
>> areas have done.
>>
>> For pcifront_rescan_root(), it will return error code ("num_roots = 0;",
>> skip xenbus_switch_state return value).
>> 
>> For pcifront_scan_root(), it will return 0 ("num_roots = 0;", set 0 by
>> the return value of xenbus_switch_state, which always return 0, at
>> present).
>
>The changelog is somewhat confusing because it talks about the patch hunks
>in reverse order (the pcifront_scan_root() change is first in the patch,
>but the changelog mentions pcifront_rescan_root() first).  I *think* this
>means:
>
>  When pcifront_try_connect() finds no PCI roots, it falls back to calling
>  pcifront_scan_root() for 0000:00.  If that fails, it used to switch to
>  XenbusStateConnected and return success (because xenbus_switch_state()
>  currently always succeeds).
>
>  If pcifront_scan_root() fails, leave the XenbusState unchanged and
>  return an error code.
>
>  Similarly, pcifront_attach_devices() falls back to calling
>  pcifront_rescan_root() for 0000:00.  If that fails, it used to 
>  switch to XenbusStateConnected and return an error code.
>
>  If pcifront_rescan_root() fails, leave the XenbusState unchanged and
>  return the error code.
>
>The "num_roots" part doesn't seem relevant to me.
>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>
>Konrad, if you want to take this, feel free.  Otherwise, if you ack it and
>you think my changelog understanding makes sense, I can pick it up.
>
>It does seem odd that pcifront_attach_devices() ignores the
>xenbus_switch_state() return value while pcifront_try_connect() does not.
>But many other callers also ignore the return value, so maybe that's OK.
>
>Bjorn
>
>> ---
>>  drivers/pci/xen-pcifront.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>> 
>> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
>> index 53df39a..d78d884 100644
>> --- a/drivers/pci/xen-pcifront.c
>> +++ b/drivers/pci/xen-pcifront.c
>> @@ -866,6 +866,11 @@ static int pcifront_try_connect(struct pcifront_device *pdev)
>>  		xenbus_dev_error(pdev->xdev, err,
>>  				 "No PCI Roots found, trying 0000:00");
>>  		err = pcifront_scan_root(pdev, 0, 0);
>> +		if (err) {
>> +			xenbus_dev_fatal(pdev->xdev, err,
>> +					 "Error scanning PCI root 0000:00");
>> +			goto out;
>> +		}
>>  		num_roots = 0;
>>  	} else if (err != 1) {
>>  		if (err == 0)
>> @@ -947,6 +952,11 @@ static int pcifront_attach_devices(struct pcifront_device *pdev)
>>  		xenbus_dev_error(pdev->xdev, err,
>>  				 "No PCI Roots found, trying 0000:00");
>>  		err = pcifront_rescan_root(pdev, 0, 0);
>> +		if (err) {
>> +			xenbus_dev_fatal(pdev->xdev, err,
>> +					 "Error scanning PCI root 0000:00");
>> +			goto out;
>> +		}
>>  		num_roots = 0;
>>  	} else if (err != 1) {
>>  		if (err == 0)
>> -- 
>> 1.9.3
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
