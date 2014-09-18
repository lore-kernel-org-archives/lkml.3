Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaIRNOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:14:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbaIRNOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:14:08 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
From: Alexander Graf <agraf@suse.de>
X-Mailer: iPhone Mail (11B554a)
In-Reply-To: <541A5CF1.8000409@freescale.com>
Date: Thu, 18 Sep 2014 15:14:03 +0200
Cc: Kim Phillips <kim.phillips@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<stuart.yoder@freescale.com>" <stuart.yoder@freescale.com>,
        "<scottwood@freescale.com>" <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com> <1410456864-27890-2-git-send-email-German.Rivera@freescale.com> <20140915184451.962a3a19c4940792d182f10a@freescale.com> <541A5CF1.8000409@freescale.com>
To: German Rivera <German.Rivera@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Am 18.09.2014 um 06:17 schrieb German Rivera <German.Rivera@freescale.com>:
> 
>> On 09/15/2014 06:44 PM, Kim Phillips wrote:
>> On Thu, 11 Sep 2014 12:34:21 -0500
>> "J. German Rivera" <German.Rivera@freescale.com> wrote:
>> 
>>> From: "J. German Rivera" <German.Rivera@freescale.com>
>>> 
>>> APIs to access the Management Complex (MC) hardware
>>> module of Freescale LS2 SoCs. This patch includes
>>> APIs to check the MC firmware version and to manipulate
>>> DPRC objects in the MC.
>>> 
>>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
>>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
>>> ---
>>>  drivers/bus/fsl-mc/dpmng.c         |   93 +++++
>>>  drivers/bus/fsl-mc/dprc.c          |  504 +++++++++++++++++++++++
>>>  drivers/bus/fsl-mc/fsl_dpmng_cmd.h |   83 ++++
>>>  drivers/bus/fsl-mc/fsl_dprc_cmd.h  |  545 +++++++++++++++++++++++++
>>>  drivers/bus/fsl-mc/fsl_mc_sys.c    |  237 +++++++++++
>>>  include/linux/fsl_dpmng.h          |  120 ++++++
>>>  include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
>>>  include/linux/fsl_mc_cmd.h         |  182 +++++++++
>>>  include/linux/fsl_mc_sys.h         |   81 ++++
>>>  9 files changed, 2635 insertions(+)
>>>  create mode 100644 drivers/bus/fsl-mc/dpmng.c
>>>  create mode 100644 drivers/bus/fsl-mc/dprc.c
>>>  create mode 100644 drivers/bus/fsl-mc/fsl_dpmng_cmd.h
>>>  create mode 100644 drivers/bus/fsl-mc/fsl_dprc_cmd.h
>>>  create mode 100644 drivers/bus/fsl-mc/fsl_mc_sys.c
>>>  create mode 100644 include/linux/fsl_dpmng.h
>>>  create mode 100644 include/linux/fsl_dprc.h
>>>  create mode 100644 include/linux/fsl_mc_cmd.h
>>>  create mode 100644 include/linux/fsl_mc_sys.h
>> 
>> the fsl prefix in the filename fsl_dpmng_cmd.h is redundant with
>> its directory name fsl-mc/.  Note that I find dashes ('-') in
>> filenames make them easier to type: is there a reason we're using
>> underscores here?
> This is a convention that we decided early on '-' for directory names
> and '_' for file names.
> 
>> Also, any reason why these and future include files aren't being put
>> in include/linux/fsl/, so as to not pollute the top level
>> include/linux/?  That way, we can also remove the fsl- prefix from
>> those filenames, too..
> I would like to receive opinions from others about this before making any change here.
> 
>>> diff --git a/drivers/bus/fsl-mc/dpmng.c b/drivers/bus/fsl-mc/dpmng.c
>>> new file mode 100644
>>> index 0000000..c6ed27c
>>> --- /dev/null
>>> +++ b/drivers/bus/fsl-mc/dpmng.c
>>> @@ -0,0 +1,93 @@
>>> +/* Copyright 2013-2014 Freescale Semiconductor Inc.
>>> + *
>>> + * Redistribution and use in source and binary forms, with or without
>>> + * modification, are permitted provided that the following conditions are met:
>>> + *     * Redistributions of source code must retain the above copyright
>>> + *       notice, this list of conditions and the following disclaimer.
>>> + *     * Redistributions in binary form must reproduce the above copyright
>>> + *       notice, this list of conditions and the following disclaimer in the
>>> + *       documentation and/or other materials provided with the distribution.
>>> + *     * Neither the name of Freescale Semiconductor nor the
>>> + *       names of its contributors may be used to endorse or promote products
>>> + *       derived from this software without specific prior written permission.
>>> + *
>>> + *
>>> + * ALTERNATIVELY, this software may be distributed under the terms of the
>>> + * GNU General Public License ("GPL") as published by the Free Software
>>> + * Foundation, either version 2 of that License or (at your option) any
>>> + * later version.
>>> + *
>>> + * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
>> 
>> interesting, normally this text reads:
>> 
>> "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS"
>> 
>> ...does that mean we're excluding non-Freescale copyright holders
>> and contributors from this warranty statement?  That doesn't seem
>> appropriate for an upstream kernel submission.
> I would like to receive opinions from others about this before making any change here.

IANAL, but I would prefer to have this identical to the rest of Linux to be on the safe side.

> 
>>> + * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
>>> + * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
>>> + * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
>>> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
>>> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
>>> + * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
>>> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
>>> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
>>> + * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>>> + */
>> 
>> This dual BSD-3-clause/GPL license doesn't match that of patch 2's
>> drivers/bus/fsl-mc/fsl_mc_bus.c, GPLv2:
> This is because the MC flib files in patch 1 can also be used in user-space code not just in the kernel. I will not make any change to the licenses of the MC flib files included in patch 1.
> 
>> +/*
>> + * Freescale Management Complex (MC) bus driver
>> + *
>> + * Copyright (C) 2014 Freescale Semiconductor, Inc.
>> + * Author: German Rivera <German.Rivera@freescale.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2. This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> 
>> any reason the licenses are different?
> Different teams wrote the files.
> 
>>> +int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info)
>>> +{
>>> +    struct mc_command cmd = { 0 };
>> 
>> we can save some cycles if this initialization is not absolutely
>> necessary: is it?  i.e., does the h/w actually look at the params
>> section when doing a get_version?  not sure to what other commands
>> this comment would apply to...at least get_container_id, but maybe
>> more - all of them?
> I agree with the response from Scott Wood. I will not change this.
> 
>>> diff --git a/drivers/bus/fsl-mc/fsl_mc_sys.c b/drivers/bus/fsl-mc/fsl_mc_sys.c
>> 
>>> +/**
>>> + * Map an MC portal in the kernel virtual address space
>>> + */
>>> +static int map_mc_portal(phys_addr_t mc_portal_phys_addr,
>>> +             uint32_t mc_portal_size,
>>> +             void __iomem **new_mc_portal_virt_addr)
>>> +{
>>> +    void __iomem *mc_portal_virt_addr = NULL;
>>> +    struct resource *res = NULL;
>>> +    int error = -EINVAL;
>>> +
>>> +    res =
>>> +        request_mem_region(mc_portal_phys_addr, mc_portal_size,
>>> +                   "mc_portal");
>>> +    if (res == NULL) {
>>> +        pr_err("request_mem_region() failed for MC portal %#llx\n",
>>> +               mc_portal_phys_addr);
>>> +        error = -EBUSY;
>>> +        goto error;
>>> +    }
>>> +
>>> +    mc_portal_virt_addr = ioremap_nocache(mc_portal_phys_addr,
>>> +                          mc_portal_size);
>>> +    if (mc_portal_virt_addr == NULL) {
>>> +        pr_err("ioremap_nocache() failed for MC portal %#llx\n",
>>> +               mc_portal_phys_addr);
>>> +        error = -EFAULT;
>>> +        goto error;
>>> +    }
>>> +
>>> +    *new_mc_portal_virt_addr = mc_portal_virt_addr;
>>> +    return 0;
>>> +error:
>>> +    if (mc_portal_virt_addr != NULL)
>>> +        iounmap(mc_portal_virt_addr);
>>> +
>>> +    if (res != NULL)
>>> +        release_mem_region(mc_portal_phys_addr, mc_portal_size);
>>> +
>>> +    return error;
>>> +}
>> 
>> unnecessary initializations, bad error codes (both should be
>> -ENOMEM),
> >
> I disagree, the ioremap_nocache() failure should not be treated
> as ENOMEM. As Scott Wood suggested, I'll change the EFAULT error
> to ENXIO error.
> 
> unnecessarily complicated error path, plus a simpler
>> implementation can be made if fn can return the mapped address, like
>> so:
>> 
>> static void __iomem *map_mc_portal(phys_addr_t mc_portal_phys_addr,
>>                                    uint32_t mc_portal_size)
>> {
>>         struct resource *res;
>>         void __iomem *mapped_addr;
>> 
>>         res = request_mem_region(mc_portal_phys_addr, mc_portal_size,
>>                                  "mc_portal");
>>         if (!res)
>>                 return NULL;
>> 
>>         mapped_addr = ioremap_nocache(mc_portal_phys_addr,
>>                                       mc_portal_size);
>>         if (!mapped_addr)
>>                 release_mem_region(mc_portal_phys_addr, mc_portal_size);
>> 
>>         return mapped_addr;
>> }
>> 
>> the callsite can return -ENOMEM to its caller if returned NULL.  This
>> can be improved even further if devm_ functions are used:  this is
>> just an example of how to simplify the code using early returns
>> instead of goto error.
> 
> I disagree. Having a common error return point is more maintainable than having multiple returns as having the clean-up logic in one place is more maintainable and makes the min path (non-error) more readable.
> 
>> 
>>> +int __must_check fsl_create_mc_io(phys_addr_t mc_portal_phys_addr,
>>> +                  uint32_t mc_portal_size,
>>> +                  uint32_t flags, struct fsl_mc_io **new_mc_io)
>>> +{
>>> +    int error = -EINVAL;
>>> +    struct fsl_mc_io *mc_io = NULL;
>>> +
>>> +    mc_io = kzalloc(sizeof(*mc_io), GFP_KERNEL);
>>> +    if (mc_io == NULL) {
>>> +        error = -ENOMEM;
>>> +        pr_err("No memory to allocate mc_io\n");
>>> +        goto error;
>>> +    }
>>> +
>>> +    mc_io->magic = FSL_MC_IO_MAGIC;
>>> +    mc_io->flags = flags;
>>> +    mc_io->portal_phys_addr = mc_portal_phys_addr;
>>> +    mc_io->portal_size = mc_portal_size;
>>> +    spin_lock_init(&mc_io->spinlock);
>>> +    error = map_mc_portal(mc_portal_phys_addr,
>>> +                  mc_portal_size, &mc_io->portal_virt_addr);
>>> +    if (error < 0)
>>> +        goto error;
>>> +
>>> +    *new_mc_io = mc_io;
>>> +    return 0;
>> 
>> if a fn only returns an address or error, it can return ERR_PTR
>> (e.g., -ENOMEM), and the callsite use IS_ERR() to determine whether
>> there was an error or address returned.  This makes code much
>> simpler instead of passing address values back by reference.
> I disagree. I don't see why the alternative you suggest makes the code "much simpler".
> 
>>> +error:
>>> +    if (mc_io != NULL) {
>>> +        if (mc_io->portal_virt_addr != NULL) {
>>> +            unmap_mc_portal(mc_portal_phys_addr,
>>> +                    mc_portal_size,
>>> +                    mc_io->portal_virt_addr);
>>> +        }
>>> +
>>> +        kfree(mc_io);
>> 
>> kfree can handle being passed NULL, but again, might want to
>> consider using devm_ functions instead.
> No. We cannot use devm_ functions here as there is no device passed in.

Is it a good idea to lose your device context in any function? Whenever I dropped contexts in helper I usually ended up regretting it later ;).

> 
>>> +    }
>>> +
>>> +    return error;
>>> +}
>>> +EXPORT_SYMBOL_GPL(fsl_create_mc_io);
>>> +
>>> +void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
>>> +{
>>> +    if (WARN_ON(mc_io->magic != FSL_MC_IO_MAGIC))
>>> +        return;
>>> +
>>> +    if (mc_io->portal_virt_addr != NULL) {
>>> +        unmap_mc_portal(mc_io->portal_phys_addr,
>>> +                mc_io->portal_size, mc_io->portal_virt_addr);
>> 
>> unmap_mc_portal already checks for virt_addr, this is another
>> example where the code goes too far checking for NULL.
> I disagree. Having the extra check is harmless and more importantly makes the intent explicit that we should only call unmap_mc_portal if we called map_mc_portal earlier.
> 
>>> +        mc_io->portal_virt_addr = NULL;
>>> +    }
>>> +
>>> +    mc_io->magic = 0x0;
>>> +    kfree(mc_io);
>>> +}
>>> +EXPORT_SYMBOL_GPL(fsl_destroy_mc_io);
>>> +
>>> +static int mc_status_to_error(enum mc_cmd_status status)
>>> +{
>>> +    switch (status) {
>>> +    case MC_CMD_STATUS_OK:
>>> +        return 0;
>>> +    case MC_CMD_STATUS_AUTH_ERR:
>>> +        return -EACCES;
>>> +    case MC_CMD_STATUS_NO_PRIVILEGE:
>>> +        return -EPERM;
>>> +    case MC_CMD_STATUS_DMA_ERR:
>>> +        return -EIO;
>>> +    case MC_CMD_STATUS_CONFIG_ERR:
>>> +        return -EINVAL;
>>> +    case MC_CMD_STATUS_TIMEOUT:
>>> +        return -ETIMEDOUT;
>>> +    case MC_CMD_STATUS_NO_RESOURCE:
>>> +        return -ENAVAIL;
>>> +    case MC_CMD_STATUS_NO_MEMORY:
>>> +        return -ENOMEM;
>>> +    case MC_CMD_STATUS_BUSY:
>>> +        return -EBUSY;
>>> +    case MC_CMD_STATUS_UNSUPPORTED_OP:
>>> +        return -ENOTSUP;
>>> +    case MC_CMD_STATUS_INVALID_STATE:
>>> +        return -ENODEV;
>>> +    default:
>>> +        break;
>>> +    }
>>> +
>>> +    /* Not expected to reach here */
>>> +    return -EINVAL;
>> 
>> but if it does, callsite can't disambiguate between that and e.g.,
>> MC_CMD_STATUS_CONFIG_ERR.  Also, this would be more readable as a
>> static const lookup table.
> I will change the switch to a lookup table and fix the -EINVAL
> ambiguity in the v2 respin.
> 
>> 
>>> +}
>>> +
>>> +int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
>>> +{
>>> +    enum mc_cmd_status status;
>>> +    unsigned long irqsave_flags = 0;
>>> +    int error = -EINVAL;
>>> +    bool lock_acquired = false;
>>> +    unsigned long jiffies_until_timeout =
>>> +        jiffies + MC_CMD_COMPLETION_TIMEOUT;
>>> +
>>> +    if (WARN_ON(mc_io->magic != FSL_MC_IO_MAGIC))
>>> +        goto out;
>> 
>> if the h/w signals an error on the bad magic condition, s/w doesn't
>> need to check it in its fast path.
> As per comments from Arnd Bergmann on the RFC patch series, I removed the magic field from all structs. I just forgot to do it for this one.
> I will remove this magic field in the v2 respin.
> 
>>> +    if (mc_io->flags & FSL_MC_IO_PORTAL_SHARED) {
>>> +        spin_lock_irqsave(&mc_io->spinlock, irqsave_flags);
>>> +        lock_acquired = true;
>>> +    }
>>> +
>>> +    mc_write_command(mc_io->portal_virt_addr, cmd);
>>> +
>>> +    for (;;) {
>>> +        status = mc_read_response(mc_io->portal_virt_addr, cmd);
>>> +        if (status != MC_CMD_STATUS_READY)
>>> +            break;
>>> +
>>> +        /*
>>> +         * TODO: When MC command completion interrupts are supported
>>> +         * call wait function here instead of udelay()
>>> +         */
>>> +        udelay(MC_CMD_COMPLETION_POLLING_INTERVAL);
>>> +        if (time_after_eq(jiffies, jiffies_until_timeout)) {
>>> +            error = -ETIMEDOUT;
>>> +            goto out;
>>> +        }
>>> +    }
>>> +
>>> +    error = mc_status_to_error(status);
>>> +out:
>>> +    if (lock_acquired)
>>> +        spin_unlock_irqrestore(&mc_io->spinlock, irqsave_flags);
>> 
>> so if the portal is shared, we take a lock, disable interrupts, and
>> then potentially udelay for a whopping 500usec, then check to see if
>> _100_usec have passed, and thus _always_ issue a timeout error, even
>> if the device took < 100usec to consume the command???
> That is not true. The 100 is in jiffies not in usec:

If you always wait for 100 jiffies, the timeout code suddenly depends on the HZ value which is kernel configuration, no? Wouldn't it be better to base the timeout on real wall time?

> 
> /**
> * Timeout in jiffies to wait for the completion of an MC command
> */
> #define MC_CMD_COMPLETION_TIMEOUT   100
> 
> /**
> * Delay in microseconds between polling iterations while
> * waiting for MC command completion
> */
> #define MC_CMD_COMPLETION_POLLING_INTERVAL  500
> 
> 
>> Not to mention this code will spin perpetually with IRQs disabled if
>> the read_response never returns ready.  I also don't see a reason
>> why IRQs are being disabled in the first place - it's not being used
>> in an IRQ handler...perhaps we need to wait until command completion
>> IRQs are supported :)
> I agree that disabling interrupts while doing polling is not efficient. I was assuming the worst case scenario of sharing the portal: both
> threads and interrupt handlers accessing the same portal at the same time. If only threads access the same portal, we don't need to disable interrupts and even further we can use a mutex instead of a spinlock.
> If only interrupt handlers access a given portal (from multiple CPUs)
> we have use a spinlock but we don't need to disabel interrupts.
> If both threads and interrupt handlers access a given portal, then
> we need to both use a spinlock and disable interrupts
> 
> I will change synchronization logic in the v2 respin to avoid
> disabling interrupts in the first two cases above.
> 
>>> +/**
>>> + * @brief    Management Complex firmware version information
>>> + */
>>> +#define MC_VER_MAJOR 2
>>> +#define MC_VER_MINOR 0
>> 
>> code should be adjusted to run on all *compatible* versions of h/w,
>> not strictly the one set in these defines.
> This comment is not precise enough be actionable.
> What exactly you want to be changed  here?

I think the easy thing to do is to convert the exact version check into a ranged version check: have minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the version at all - or only for the major version and guarantee that the major version indicates backwards compatibility.

> 
>>> +/**
>>> + * @brief    Disconnects one endpoint to remove its network link
>>> + *
>>> + * @param[in]   mc_io        Pointer to opaque I/O object
>>> + * @param[in]    dprc_handle    Handle to the DPRC object
>>> + * @param[in]   endpoint    Endpoint configuration parameters.
>>> + *
>>> + * @returns    '0' on Success; Error code otherwise.
>>> + * */
>>> +int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
>>> +            struct dprc_endpoint *endpoint);
>>> +
>>> +/*! @} */
>> 
>> this entire file is riddled with non-kernel-doc comment markers:  see
>> Documentation/kernel-doc-nano-HOWTO.txt on how to write function and
>> other types of comments in a kernel-doc compliant format.
> This is because this file is using doxygen comments, as it was developed
> by another team. Unless someone else has an objection, I will leave the doxygen comments alone and not make any change here.

Do you see any other source files in Linux using doxygen comments? Mixing different documentation styles can easily become a big mess, because you can't generate external documentation consistently for the whole tree.


Alex

