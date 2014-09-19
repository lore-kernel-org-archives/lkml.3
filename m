Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaISCei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 22:34:38 -0400
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:15280
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751223AbaISCeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 22:34:36 -0400
X-Greylist: delayed 7402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 22:34:36 EDT
Message-ID: <541B9630.5080402@freescale.com>
Date: Thu, 18 Sep 2014 21:34:24 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Kim Phillips <kim.phillips@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<stuart.yoder@freescale.com>" <stuart.yoder@freescale.com>,
        "<scottwood@freescale.com>" <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com> <1410456864-27890-2-git-send-email-German.Rivera@freescale.com> <20140915184451.962a3a19c4940792d182f10a@freescale.com> <541A5CF1.8000409@freescale.com> <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
In-Reply-To: <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: DM2PR04CA042.namprd04.prod.outlook.com (10.141.154.160) To
 DM2PR03MB336.namprd03.prod.outlook.com (10.141.54.25)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB336;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(51704005)(189002)(199003)(35774003)(377454003)(24454002)(479174003)(90102001)(42186005)(110136001)(80316001)(83072002)(47776003)(85306004)(23746002)(50466002)(65956001)(107046002)(86362001)(64706001)(65816999)(50986999)(92566001)(66066001)(93886004)(105586002)(92726001)(85852003)(95666004)(77096002)(87266999)(81542003)(33656002)(74662003)(102836001)(65806001)(54356999)(81342003)(99396002)(97736003)(64126003)(46102003)(76482002)(36756003)(106356001)(21056001)(31966008)(20776003)(76176999)(19580395003)(74502003)(77982003)(83506001)(83322001)(80022003)(87976001)(79102003)(4396001)(101416001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB336;H:[10.214.83.219];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 08:14 AM, Alexander Graf wrote:
>

>>>
>>>> +int __must_check fsl_create_mc_io(phys_addr_t mc_portal_phys_addr,
>>>> +                  uint32_t mc_portal_size,
>>>> +                  uint32_t flags, struct fsl_mc_io **new_mc_io)
>>>> +{
>>>> +    int error = -EINVAL;
>>>> +    struct fsl_mc_io *mc_io = NULL;
>>>> +
>>>> +    mc_io = kzalloc(sizeof(*mc_io), GFP_KERNEL);
>>>> +    if (mc_io == NULL) {
>>>> +        error = -ENOMEM;
>>>> +        pr_err("No memory to allocate mc_io\n");
>>>> +        goto error;
>>>> +    }
>>>> +
>>>> +    mc_io->magic = FSL_MC_IO_MAGIC;
>>>> +    mc_io->flags = flags;
>>>> +    mc_io->portal_phys_addr = mc_portal_phys_addr;
>>>> +    mc_io->portal_size = mc_portal_size;
>>>> +    spin_lock_init(&mc_io->spinlock);
>>>> +    error = map_mc_portal(mc_portal_phys_addr,
>>>> +                  mc_portal_size, &mc_io->portal_virt_addr);
>>>> +    if (error < 0)
>>>> +        goto error;
>>>> +
>>>> +    *new_mc_io = mc_io;
>>>> +    return 0;
>>>
>>> if a fn only returns an address or error, it can return ERR_PTR
>>> (e.g., -ENOMEM), and the callsite use IS_ERR() to determine whether
>>> there was an error or address returned.  This makes code much
>>> simpler instead of passing address values back by reference.
>> I disagree. I don't see why the alternative you suggest makes the code "much simpler".
>>
>>>> +error:
>>>> +    if (mc_io != NULL) {
>>>> +        if (mc_io->portal_virt_addr != NULL) {
>>>> +            unmap_mc_portal(mc_portal_phys_addr,
>>>> +                    mc_portal_size,
>>>> +                    mc_io->portal_virt_addr);
>>>> +        }
>>>> +
>>>> +        kfree(mc_io);
>>>
>>> kfree can handle being passed NULL, but again, might want to
>>> consider using devm_ functions instead.
>> No. We cannot use devm_ functions here as there is no device passed in.
>
> Is it a good idea to lose your device context in any function? Whenever I dropped contexts in helper I usually ended up regretting it later ;).
>
OK, I will add a dev param to this the fsl_mc_io_create() function, to
enable the use of devm_ APIs.

>>>> +    if (mc_io->flags & FSL_MC_IO_PORTAL_SHARED) {
>>>> +        spin_lock_irqsave(&mc_io->spinlock, irqsave_flags);
>>>> +        lock_acquired = true;
>>>> +    }
>>>> +
>>>> +    mc_write_command(mc_io->portal_virt_addr, cmd);
>>>> +
>>>> +    for (;;) {
>>>> +        status = mc_read_response(mc_io->portal_virt_addr, cmd);
>>>> +        if (status != MC_CMD_STATUS_READY)
>>>> +            break;
>>>> +
>>>> +        /*
>>>> +         * TODO: When MC command completion interrupts are supported
>>>> +         * call wait function here instead of udelay()
>>>> +         */
>>>> +        udelay(MC_CMD_COMPLETION_POLLING_INTERVAL);
>>>> +        if (time_after_eq(jiffies, jiffies_until_timeout)) {
>>>> +            error = -ETIMEDOUT;
>>>> +            goto out;
>>>> +        }
>>>> +    }
>>>> +
>>>> +    error = mc_status_to_error(status);
>>>> +out:
>>>> +    if (lock_acquired)
>>>> +        spin_unlock_irqrestore(&mc_io->spinlock, irqsave_flags);
>>>
>>> so if the portal is shared, we take a lock, disable interrupts, and
>>> then potentially udelay for a whopping 500usec, then check to see if
>>> _100_usec have passed, and thus _always_ issue a timeout error, even
>>> if the device took < 100usec to consume the command???
>> That is not true. The 100 is in jiffies not in usec:
>
> If you always wait for 100 jiffies, the timeout code suddenly depends on the HZ value which is kernel configuration, no? Wouldn't it be better to base the timeout on real wall time?
>
I will change the value of the timeout to be a function of HZ instead of 
a hard-coded jiffies value. Also, to avoid future confusion, I'll
rename the timeout and delay macros to include their units:

/**
  * Timeout in jiffies to wait for the completion of an MC command
  */
#define MC_CMD_COMPLETION_TIMEOUT_JIFFIES   (HZ / 2)	/* 500 ms */

/**
  * Delay in microseconds between polling iterations while
  * waiting for MC command completion
  */
#define MC_CMD_COMPLETION_POLLING_INTERVAL_USECS    500	/* 0.5 ms */

>>
>> /**
>> * Timeout in jiffies to wait for the completion of an MC command
>> */
>> #define MC_CMD_COMPLETION_TIMEOUT   100
>>
>> /**
>> * Delay in microseconds between polling iterations while
>> * waiting for MC command completion
>> */
>> #define MC_CMD_COMPLETION_POLLING_INTERVAL  500
>>
>>
>>> Not to mention this code will spin perpetually with IRQs disabled if
>>> the read_response never returns ready.  I also don't see a reason
>>> why IRQs are being disabled in the first place - it's not being used
>>> in an IRQ handler...perhaps we need to wait until command completion
>>> IRQs are supported :)
>> I agree that disabling interrupts while doing polling is not efficient. I was assuming the worst case scenario of sharing the portal: both
>> threads and interrupt handlers accessing the same portal at the same time. If only threads access the same portal, we don't need to disable interrupts and even further we can use a mutex instead of a spinlock.
>> If only interrupt handlers access a given portal (from multiple CPUs)
>> we have use a spinlock but we don't need to disabel interrupts.
>> If both threads and interrupt handlers access a given portal, then
>> we need to both use a spinlock and disable interrupts
>>
>> I will change synchronization logic in the v2 respin to avoid
>> disabling interrupts in the first two cases above.
>>
>>>> +/**
>>>> + * @brief    Management Complex firmware version information
>>>> + */
>>>> +#define MC_VER_MAJOR 2
>>>> +#define MC_VER_MINOR 0
>>>
>>> code should be adjusted to run on all *compatible* versions of h/w,
>>> not strictly the one set in these defines.
>> This comment is not precise enough be actionable.
>> What exactly you want to be changed  here?
>
> I think the easy thing to do is to convert the exact version check into a ranged version check: have minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the version at all - or only for the major version and guarantee that the major version indicates backwards compatibility.
>
I will keep only the major version check and remove the minor version check.

>>
>>>> +/**
>>>> + * @brief    Disconnects one endpoint to remove its network link
>>>> + *
>>>> + * @param[in]   mc_io        Pointer to opaque I/O object
>>>> + * @param[in]    dprc_handle    Handle to the DPRC object
>>>> + * @param[in]   endpoint    Endpoint configuration parameters.
>>>> + *
>>>> + * @returns    '0' on Success; Error code otherwise.
>>>> + * */
>>>> +int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
>>>> +            struct dprc_endpoint *endpoint);
>>>> +
>>>> +/*! @} */
>>>
>>> this entire file is riddled with non-kernel-doc comment markers:  see
>>> Documentation/kernel-doc-nano-HOWTO.txt on how to write function and
>>> other types of comments in a kernel-doc compliant format.
>> This is because this file is using doxygen comments, as it was developed
>> by another team. Unless someone else has an objection, I will leave the doxygen comments alone and not make any change here.
>
> Do you see any other source files in Linux using doxygen comments? Mixing different documentation styles can easily become a big mess, because you can't generate external documentation consistently for the whole tree.
>
>
Stuart already answered this question.


> Alex
>
