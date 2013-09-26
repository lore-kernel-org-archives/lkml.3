Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3IZJZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:25:48 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:35929 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3IZJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:25:46 -0400
MIME-Version: 1.0
In-Reply-To: <CACQ1gAgqfHXwLjxhy9RrzFWe93Vmnc0chOg6uRKyqb6sVVQKxw@mail.gmail.com>
References: <1380141125-11063-1-git-send-email-richard@nod.at>
 <5243E033.7010403@gmail.com> <5243E130.3040200@nod.at> <CACQ1gAgqfHXwLjxhy9RrzFWe93Vmnc0chOg6uRKyqb6sVVQKxw@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 26 Sep 2013 11:25:23 +0200
Message-ID: <CACQ1gAjrSZv61sow6Ows50fu+ptjr3swqXDQT7NYGWqEx-w2Lg@mail.gmail.com>
Subject: Re: [PATCH 1/2] UBI: Fix error path in scan_pool()
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/9/26 Richard Genoud <richard.genoud@gmail.com>:
> 2013/9/26 Richard Weinberger <richard@nod.at>:
>> Am 26.09.2013 09:20, schrieb Richard Genoud:
>>> On 25/09/2013 22:32, Richard Weinberger wrote:
>>>> We have to set "ret", not "err" in case of an error.
>>>>
>>>> Reported-by: Richard Genoud <richard.genoud@gmail.com>
>>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>>> ---
>>>>  drivers/mtd/ubi/fastmap.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
>>>> index f5aa4b0..9b42add 100644
>>>> --- a/drivers/mtd/ubi/fastmap.c
>>>> +++ b/drivers/mtd/ubi/fastmap.c
>>>> @@ -428,7 +428,7 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
>>>>              if (be32_to_cpu(ech->image_seq) != ubi->image_seq) {
>>>>                      ubi_err("bad image seq: 0x%x, expected: 0x%x",
>>>>                              be32_to_cpu(ech->image_seq), ubi->image_seq);
>>>> -                    err = UBI_BAD_FASTMAP;
>>>> +                    ret = UBI_BAD_FASTMAP;
>>>>                      goto out;
>>>>              }
>>>>
>>>>
>>>
>>> Tested-by: Richard Genoud <richard.genoud@gmail.com>
>>>
>>> It reveals another bug though.
>>>
>>> [    0.812500] UBI: default fastmap pool size: 95
>>> [    0.820312] UBI: default fastmap WL pool size: 25
>>> [    0.820312] UBI: attaching mtd2 to ubi0
>>> [    0.914062] UBI error: scan_pool: bad image seq: 0x0, expected: 0x352a9728
>>
>> This worries me more...
>> The fastmap is corrupted, now we have to find out why.
>> Broken driver? Powercut? IO errors?
> I guess this is caused by u-boot when it deletes the UBI fastmap
> internal volume.
> I'm replaying the whole scenario with debug to see when it happens.

I added some traces and I found that : (dumping ec_header after
"ubi_io_read_ec_hdr(ubi, pnum, ech, 0); " in ubi_scan_fastmap())
[    0.812500] UBI: default fastmap pool size: 95
[    0.820312] UBI: default fastmap WL pool size: 25
[    0.828125] UBI: attaching mtd2 to ubi0
[    0.851562] ubi_scan_fastmap:
[    0.859375] Erase counter header dump:
[    0.859375]  magic          0x55424923
[    0.867187]  version        1
[    0.867187]  ec             1
[    0.867187]  vid_hdr_offset 2048
[    0.875000]  data_offset    4096
[    0.875000]  image_seq      891983656 <- image seq is good.
[    0.875000]  hdr_crc        0x13cc9a78
[    0.882812] erase counter header hexdump:
[    0.882812] 00000000: 55 42 49 23 01 00 00 00 00 00 00 00 00 00 00
01 00 00 08 00 00 00 10 00 35 2a 97
28 00 00 00 00  UBI#....................5*.(....
[    0.890625] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00
00 13 cc 9a 78  ...............................x
[    0.960937] UBI error: scan_pool: bad image seq: 0x0, expected: 0x352a9728
[    0.968750] UBI error: ubi_scan_fastmap: Attach by fastmap failed,
doing a full scan!
[    0.976562] kmem_cache_destroy ubi_ainf_peb_slab: Slab cache still
has objects
[    0.976562] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.1 #20
[    0.984375] [<c0012e20>] (unwind_backtrace+0x0/0xe0) from
[<c0010bb8>] (show_stack+0x10/0x14)
[    0.992187] [<c0010bb8>] (show_stack+0x10/0x14) from [<c01a15e4>]
(destroy_ai+0x230/0x244)
[    1.000000] [<c01a15e4>] (destroy_ai+0x230/0x244) from [<c01a2c4c>]
(ubi_attach+0x1e8/0x34c)
[    1.007812] [<c01a2c4c>] (ubi_attach+0x1e8/0x34c) from [<c0197678>]
(ubi_attach_mtd_dev+0x2b8/0x86c)
[    1.015625] [<c0197678>] (ubi_attach_mtd_dev+0x2b8/0x86c) from
[<c0346630>] (ubi_init+0x1d8/0x29c)
[    1.023437] [<c0346630>] (ubi_init+0x1d8/0x29c) from [<c0008810>]
(do_one_initcall+0x94/0x144)
[    1.031250] [<c0008810>] (do_one_initcall+0x94/0x144) from
[<c0335a9c>] (kernel_init_freeable+0xe8/0x1a
c)
[    1.039062] [<c0335a9c>] (kernel_init_freeable+0xe8/0x1ac) from
[<c0251528>] (kernel_init+0x8/0xe4)
[    1.046875] [<c0251528>] (kernel_init+0x8/0xe4) from [<c000e590>]
(ret_from_fork+0x14/0x24)
[    1.804687] UBI: scanning is finished
