Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaIYCRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:17:48 -0400
Received: from mail-bn1bon0110.outbound.protection.outlook.com ([157.56.111.110]:56976
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752344AbaIYCRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:17:45 -0400
From: "chen.fang@freescale.com" <chen.fang@freescale.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>
CC: Shengchao Guo <Shawn.Guo@freescale.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory()
 with remap_pfn_range().
Thread-Topic: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory()
 with remap_pfn_range().
Thread-Index: AQHPzMEDUFYOXamYk0u51V8bS8XVeJv58E4AgBZfxYCAAACDgIAA4emg
Date: Thu, 25 Sep 2014 02:17:42 +0000
Message-ID: <113c7da497f64f5caa7f2dab341cad60@BY2PR03MB556.namprd03.prod.outlook.com>
References: <1410326937-31140-1-git-send-email-chen.fang@freescale.com>
 <540FF70E.9050203@xs4all.nl> <5422BBDB.7050904@samsung.com>
 <5422BC49.3050000@xs4all.nl>
In-Reply-To: <5422BC49.3050000@xs4all.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB345;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(13464003)(377424004)(24454002)(479174003)(189002)(199003)(66066001)(93886004)(19580405001)(99286002)(105586002)(107046002)(19580395003)(46102003)(54356999)(76576001)(64706001)(108616004)(575784001)(31966008)(101416001)(74662003)(120916001)(83322001)(99396003)(74502003)(97736003)(95666004)(90102001)(2201001)(2656002)(76482002)(81542003)(21056001)(76176999)(83072002)(50986999)(230783001)(87936001)(106116001)(80022003)(85306004)(77982003)(86362001)(4396001)(85852003)(106356001)(92566001)(20776003)(74316001)(2501002)(79102003)(10300001)(33646002)(81342003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB345;H:BY2PR03MB556.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8P2HpNR019729

Thanks for your idea, Marek and Hans. This change makes sense. And I've already
verified it. I'll resubmit my change soon.

Best regards,
Fancy Fang

-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Wednesday, September 24, 2014 8:43 PM
To: Marek Szyprowski; Fang Chen-B47543; m.chehab@samsung.com; viro@ZenIV.linux.org.uk
Cc: Guo Shawn-R65073; linux-media@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory() with remap_pfn_range().



On 09/24/2014 02:40 PM, Marek Szyprowski wrote:
> Hello,
>
> On 2014-09-10 09:00, Hans Verkuil wrote:
>> On 09/10/14 07:28, Fancy Fang wrote:
>>> When user requests V4L2_MEMORY_MMAP type buffers, the videobuf-core 
>>> will assign the corresponding offset to the 'boff' field of the 
>>> videobuf_buffer for each requested buffer sequentially. Later, user 
>>> may call mmap() to map one or all of the buffers with the 'offset'
>>> parameter which is equal to its 'boff' value. Obviously, the 'offset'
>>> value is only used to find the matched buffer instead of to be the 
>>> real offset from the buffer's physical start address as used by 
>>> vm_iomap_memory(). So, in some case that if the offset is not zero,
>>> vm_iomap_memory() will fail.
>> Is this just a fix for something that can fail theoretically, or do 
>> you actually have a case where this happens? I am very reluctant to 
>> make any changes to videobuf. Drivers should all migrate to vb2.
>>
>> I have CC-ed Marek as well since he knows a lot more about this stuff 
>> than I do.
>
> I'm sorry for a delay, I was really busy with other things.
>
>>> Signed-off-by: Fancy Fang <chen.fang@freescale.com>
>>> ---
>>>   drivers/media/v4l2-core/videobuf-dma-contig.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c 
>>> b/drivers/media/v4l2-core/videobuf-dma-contig.c
>>> index bf80f0f..8bd9889 100644
>>> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
>>> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
>>> @@ -305,7 +305,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>>>       /* Try to remap memory */
>>>       size = vma->vm_end - vma->vm_start;
>>>       vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>>> -    retval = vm_iomap_memory(vma, mem->dma_handle, size);
>>> +    retval = remap_pfn_range(vma, vma->vm_start,
>>> +                 mem->dma_handle >> PAGE_SHIFT,
>>> +                 size, vma->vm_page_prot);
>>>       if (retval) {
>>>           dev_err(q->dev, "mmap: remap failed with error %d. ",
>>>               retval);
>
> I think we don't need to revert the code to use remap_pfn_range() 
> again (like it was in pre v3.10 times). The simplest way will be to 
> correctly fix
> vma->vm_pgoff and set it to zero before calling vm_iomap_memory(). It 
> vma->is
> done the same way in vb2_dma_contig.c:vb2_dc_mmap().
>
> To sum up - please change your patch: keep vm_iomap_memory() call and 
> add "vma->vm_pgoff = 0;" line before it with suitable comment.

Much better, I agree completely.

Regards,

	Hans
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
