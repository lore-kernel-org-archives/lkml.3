Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaISDFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 23:05:13 -0400
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:5165
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755032AbaISDFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 23:05:10 -0400
Message-ID: <541B9D5F.20008@freescale.com>
Date: Thu, 18 Sep 2014 22:05:03 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>, Alexander Graf <agraf@suse.de>
CC: "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<stuart.yoder@freescale.com>" <stuart.yoder@freescale.com>,
        "<scottwood@freescale.com>" <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>	<20140915184451.962a3a19c4940792d182f10a@freescale.com>	<541A5CF1.8000409@freescale.com>	<C6468126-D7AF-4144-992A-311C642CAD7F@suse.de> <20140918152233.41647ee517393816bb35b72a@freescale.com>
In-Reply-To: <20140918152233.41647ee517393816bb35b72a@freescale.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BN1PR02CA0029.namprd02.prod.outlook.com (10.141.56.29) To
 BLUPR03MB328.namprd03.prod.outlook.com (10.141.48.27)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(189002)(199003)(51704005)(52314003)(479174003)(24454002)(377454003)(105586002)(4396001)(106356001)(36756003)(83322001)(95666004)(85306004)(19580395003)(107046002)(77096002)(64126003)(23746002)(42186005)(99396002)(80022003)(46102003)(77982003)(74502003)(21056001)(86362001)(101416001)(76482002)(74662003)(81542003)(81342003)(79102003)(15975445006)(83506001)(64706001)(87976001)(65806001)(65956001)(66066001)(85852003)(83072002)(92726001)(50986999)(31966008)(90102001)(76176999)(54356999)(65816999)(93886004)(97736003)(50466002)(20776003)(92566001)(47776003)(102836001)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB328;H:[10.214.83.219];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/18/2014 03:22 PM, Kim Phillips wrote:
> On Thu, 18 Sep 2014 15:14:03 +0200

>>> unnecessarily complicated error path, plus a simpler
>>>> implementation can be made if fn can return the mapped address, like
>>>> so:
>>>>
>>>> static void __iomem *map_mc_portal(phys_addr_t mc_portal_phys_addr,
>>>>                                     uint32_t mc_portal_size)
>>>> {
>>>>          struct resource *res;
>>>>          void __iomem *mapped_addr;
>>>>
>>>>          res = request_mem_region(mc_portal_phys_addr, mc_portal_size,
>>>>                                   "mc_portal");
>>>>          if (!res)
>>>>                  return NULL;
>>>>
>>>>          mapped_addr = ioremap_nocache(mc_portal_phys_addr,
>>>>                                        mc_portal_size);
>>>>          if (!mapped_addr)
>>>>                  release_mem_region(mc_portal_phys_addr, mc_portal_size);
>>>>
>>>>          return mapped_addr;
>>>> }
>>>>
>>>> the callsite can return -ENOMEM to its caller if returned NULL.  This
>>>> can be improved even further if devm_ functions are used:  this is
>>>> just an example of how to simplify the code using early returns
>>>> instead of goto error.
>>>
>>> I disagree. Having a common error return point is more maintainable than having multiple returns as having the clean-up logic in one place is more maintainable and makes the min path (non-error) more readable.
>
> my comment is not that much different from Joe's here:
>
> https://lkml.org/lkml/2014/9/17/381
>
> but hopefully all this will change with a devm_ based implementation.
>
I will refactor this function to use devm_ functions, to simplify the 
error cleanup logic as you suggested, but still keep the current
signature of the function, as I don't think it is a good practice
to just return NULL in case of error, hiding the actual cause of the 
error. Also, mixing returning a valid pointer and an error encoded
as an invalid pointer is not clean and can be error-prone for callers, 
if some caller just checks for NULL instead of using IS_ERR() ir
IS_ERR_OR_NULL().


>>>>> +int __must_check fsl_create_mc_io(phys_addr_t mc_portal_phys_addr,
>>>>> +                  uint32_t mc_portal_size,
>>>>> +                  uint32_t flags, struct fsl_mc_io **new_mc_io)
>>>>> +{
>>>>> +    int error = -EINVAL;
>>>>> +    struct fsl_mc_io *mc_io = NULL;
>>>>> +
>>>>> +    mc_io = kzalloc(sizeof(*mc_io), GFP_KERNEL);
>>>>> +    if (mc_io == NULL) {
>>>>> +        error = -ENOMEM;
>>>>> +        pr_err("No memory to allocate mc_io\n");
>>>>> +        goto error;
>>>>> +    }
>>>>> +
>>>>> +    mc_io->magic = FSL_MC_IO_MAGIC;
>>>>> +    mc_io->flags = flags;
>>>>> +    mc_io->portal_phys_addr = mc_portal_phys_addr;
>>>>> +    mc_io->portal_size = mc_portal_size;
>>>>> +    spin_lock_init(&mc_io->spinlock);
>>>>> +    error = map_mc_portal(mc_portal_phys_addr,
>>>>> +                  mc_portal_size, &mc_io->portal_virt_addr);
>>>>> +    if (error < 0)
>>>>> +        goto error;
>>>>> +
>>>>> +    *new_mc_io = mc_io;
>>>>> +    return 0;
>>>>
>>>> if a fn only returns an address or error, it can return ERR_PTR
>>>> (e.g., -ENOMEM), and the callsite use IS_ERR() to determine whether
>>>> there was an error or address returned.  This makes code much
>>>> simpler instead of passing address values back by reference.
>>> I disagree. I don't see why the alternative you suggest makes the code "much simpler".
>
> because it eliminates the need for the extra pass-by-reference
> argument struct fsl_mc_io **new_mc_io.
>
Having an extra pass-by-reference argument does not make the code
that complicated. Bit more importantly the simplicity that you gain
by not using the extra pass-by-reference pointer comes at the price
of making the interface less safer to use (more error-prone
for the caller as I mentioned above), which I think it is a bad trade off.

>>>>> +void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
>>>>> +{
>>>>> +    if (WARN_ON(mc_io->magic != FSL_MC_IO_MAGIC))
>>>>> +        return;
>>>>> +
>>>>> +    if (mc_io->portal_virt_addr != NULL) {
>>>>> +        unmap_mc_portal(mc_io->portal_phys_addr,
>>>>> +                mc_io->portal_size, mc_io->portal_virt_addr);
>>>>
>>>> unmap_mc_portal already checks for virt_addr, this is another
>>>> example where the code goes too far checking for NULL.
>>> I disagree. Having the extra check is harmless and more importantly makes the intent explicit that we should only call unmap_mc_portal if we called map_mc_portal earlier.
>
> the code is doing this:
>
>          if (mc_io->portal_virt_addr != NULL) {
> 	        if (WARN_ON(mc_portal_virt_addr == NULL))
>          	        return;
>
> which is redundant and therefore makes it unnecessarily complicated,
> after all, a stack trace will occur if mc_portal_virt_addr is
> referenced anyway, making the WARN_ON clause redundant, too.
>
All this will be gone with the refactoring to use devm_ APIs.

>>>>> +        mc_io->portal_virt_addr = NULL;
>>>>> +    }
>>>>> +
>>>>> +    mc_io->magic = 0x0;
>>>>> +    kfree(mc_io);
>>>>> +}
>
> btw, what's the point of zeroing out things that are being freed?
>
In this particular case, this comment doe snot apply anymore, as
the magic filed will be removed.

>>>>> +/**
>>>>> + * @brief    Management Complex firmware version information
>>>>> + */
>>>>> +#define MC_VER_MAJOR 2
>>>>> +#define MC_VER_MINOR 0
>>>>
>>>> code should be adjusted to run on all *compatible* versions of h/w,
>>>> not strictly the one set in these defines.
>>> This comment is not precise enough be actionable.
>>> What exactly you want to be changed  here?
>>
>> I think the easy thing to do is to convert the exact version check into a ranged version check: have minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the version at all - or only for the major version and guarantee that the major version indicates backwards compatibility.
>
> yes, this was my point: elsewhere I noticed the code denies to run
> iff those defines are not matched exactly: that code should change
> to run as Alex describes.
>
As I mentioned in the reply to Alex, I will remove the minor version check.

