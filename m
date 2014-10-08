Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaJHFgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 01:36:23 -0400
Received: from ozlabs.org ([103.22.144.67]:57469 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaJHFgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 01:36:21 -0400
In-Reply-To: <1412678902-18672-17-git-send-email-mikey@neuling.org>
To: Michael Neuling <mikey@neuling.org>, greg@kroah.com, arnd@arndb.de,
        benh@kernel.crashing.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: cbe-oss-dev@lists.ozlabs.org, mikey@neuling.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        imunsie@au.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Subject: Re: [v3,16/16] cxl: Add documentation for userspace APIs
Message-Id: <20141008053620.2FAF014003E@ozlabs.org>
Date: Wed,  8 Oct 2014 16:36:19 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-10 at 10:48:22 UTC, Michael Neuling wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> This documentation gives an overview of the hardware architecture, userspace
> APIs via /dev/cxl/afu0.0 and the syfs files. It also adds a MAINTAINERS file

Elsewhere you talk about /dev/cxl/afuM.N, please be consistent.

> diff --git a/Documentation/ABI/testing/sysfs-class-cxl b/Documentation/ABI/testing/sysfs-class-cxl
> new file mode 100644
> index 0000000..ca429fc
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-cxl
> @@ -0,0 +1,142 @@
> +Slave contexts (eg. /sys/class/cxl/afu0.0):

Don't slave contexts end with 's' ?

> +
> +What:		/sys/class/cxl/<afu>/irqs_max
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>

We just had to fix up a bunch of these for someone who left IBM. Would it be
better if they just pointed to linuxppc-dev ?

> +Description:	read only
> +		Maximum number of interrupts that can be requested by userspace.
> +		The default on probe is the maximum that hardware can support
> +		(eg. 2037). Write values will limit userspace applications to

I thought it was read only?

> +		that many userspace interrupts. Must be >= irqs_min.

Decimal, hex?

> +What:		/sys/class/cxl/<afu>/irqs_min
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		The minimum number of interrupts that userspace must request
> +		on a CXL_START_WORK ioctl. Userspace may omit the
> +		num_interrupts field in the START_WORK IOCTL to get this
> +		minimum automatically.
> +
> +What:		/sys/class/cxl/<afu>/mmio_size
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		Size of the MMIO space that may be mmaped by userspace.

Decimal, hex? Bytes, KB ?

> +What:		/sys/class/cxl/<afu>/models_supported
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		List of the models this AFU supports.

So there can be more than one? How are multiple values separated?

> +		Valid entries are: "dedicated_process" and "afu_directed"
> +
> +What:		/sys/class/cxl/<afu>/model
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read/write
> +		The current model the AFU is using. Will be one of the models
> +		given in models_supported. Writing will change the model
> +		provided that no user contexts are attached.
> +
> +
> +What:		/sys/class/cxl/<afu>/prefault_mode
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read/write
> +		Set the mode for prefaulting in segments into the segment table
> +		when performing the START_WORK ioctl. Possible values:
> +			none: No prefaulting (default)
> +			wed: Treat the wed as an effective address and prefault it
> +			all: all segments this process currently maps

"this" process is not entirely clear. You mean "the process that calls START_WORK" ?


> +What:		/sys/class/cxl/<afu>/reset
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	write only
> +		Reset the AFU.

How does this interact with the chardev API? Do my contexts go away or stop
working or anything?

> +What:		/sys/class/cxl/<afu>/api_version
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		List the current version of the kernel/user API.

Show not List. Decimal, hex?

> +What:		/sys/class/cxl/<afu>/api_version_com
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		List the lowest version the kernel/user API this
> +		kernel is compatible with.

Show not List. Decimal, hex?

And needs to be clearer:

"The lowest version of the userspace API that this kernel supports."


> +Master contexts (eg. /sys/class/cxl/afu0.0m)
> +
> +What:		/sys/class/cxl/<afu>m/mmio_size
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		Size of the MMIO space that may be mmaped by userspace. This
> +		includes all slave contexts space also.

Units.

> +What:		/sys/class/cxl/<afu>m/pp_mmio_len
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		Per Process MMIO space length.

Units.

> +What:		/sys/class/cxl/<afu>m/pp_mmio_off
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		Per Process MMIO space offset.

Units.

> +Card info (eg. /sys/class/cxl/card0)
> +
> +What:		/sys/class/cxl/<card>/caia_version
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		Identifies the CAIA Version the card implements.
> +
> +What:		/sys/class/cxl/<card>/psl_version
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		Identifies the revision level of the PSL.
> +
> +What:		/sys/class/cxl/<card>/base_image
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		Identifies the revision level of the base image for devices
> +		that support load-able PSLs. For FPGAs this field identifies

loadable is one word.

> +		the image contained in the on-adapter flash which is loaded
> +		during the initial program load

Full stop missing.

> +What:		/sys/class/cxl/<card>/image_loaded
> +Date:		September 2014
> +Contact:	Ian Munsie <imunsie@au1.ibm.com>,
> +		Michael Neuling <mikey@neuling.org>
> +Description:	read only
> +		Will return "user" or "factory" depending on the image loaded
> +		onto the card

Full stop missing.

> diff --git a/Documentation/powerpc/00-INDEX b/Documentation/powerpc/00-INDEX
> index a68784d..116d94d 100644
> --- a/Documentation/powerpc/00-INDEX
> +++ b/Documentation/powerpc/00-INDEX
> @@ -28,3 +28,5 @@ ptrace.txt
>  	- Information on the ptrace interfaces for hardware debug registers.
>  transactional_memory.txt
>  	- Overview of the Power8 transactional memory support.
> +cxl.txt
> +	- Overview of the CXL driver.

This file is not entirely in alphabetical order, but don't make it worse :)


> diff --git a/Documentation/powerpc/cxl.txt b/Documentation/powerpc/cxl.txt
> new file mode 100644
> index 0000000..36f7ba4
> --- /dev/null
> +++ b/Documentation/powerpc/cxl.txt
> @@ -0,0 +1,346 @@
> +Coherent Accelerator Interface (CXL)
> +====================================
> +
> +Introduction
> +============
> +
> +    The coherent accelerator interface is designed to allow the
> +    coherent connection of FPGA based accelerators (and other devices)

Or "connection of accelerators (FPGAs and other devices)" ?

Below you use FPGA a few times, should they also be "accelerator" or something
more generic?

Also you use "64bit" a bunch, it's "64-bit" :)

> +    to a POWER system. These devices need to adhere to the Coherent
> +    Accelerator Interface Architecture (CAIA).

It would be good to briefly describe what "coherent" means in this context, you
use it a lot.

> +    IBM refers to this as the Coherent Accelerator Processor Interface
> +    or CAPI. In the kernel it's referred to by the name CXL to avoid
> +    confusion with the ISDN CAPI subsystem.
> +
> +Hardware overview
> +=================
> +
> +          POWER8               FPGA
> +       +----------+        +---------+
> +       |          |        |         |
> +       |   CPU    |        |   AFU   |
> +       |          |        |         |
> +       |          |        |         |
> +       |          |        |         |
> +       +----------+        +---------+
> +       |          |        |         |
> +       |   CAPP   +--------+   PSL   |
> +       |          |  PCIe  |         |
> +       +----------+        +---------+
> +
> +    The POWER8 chip has a Coherently Attached Processor Proxy (CAPP)
> +    unit which is part of the PCIe Host Bridge (PHB). This is managed
> +    by Linux by calls into OPAL. Linux doesn't directly program the
> +    CAPP.

But that's not what your diagram shows, how about:

          POWER8               FPGA
       +----------+        +---------+
       |          |        |         |
       |   CPU    |        |   AFU   |
       |          |        |         |
       |          |        |         |
       |          |        |         |
       +----------+        +---------+
       |   PHB    |        |         |
       |   +------+        |   PSL   |
       |   | CAPP |<------>|         |
       +---+------+  PCIE  +---------+

> +    The FPGA (or coherently attached device) consists of two parts.
> +    The POWER Service Layer (PSL) and the Accelerator Function Unit
> +    (AFU). AFU is used to implement specific functionality behind

The AFU

> +    the PSL. The PSL, among other things, provides memory address
> +    translation services to allow each AFU direct access to userspace
> +    memory.
> +
> +    The AFU is the core part of the accelerator (eg. the compression,
> +    crypto etc function). The kernel has no knowledge of the function
> +    of the AFU. Only userspace interacts directly with the AFU.
> +
> +    The PSL provides the translation and interrupt services that the
> +    AFU needs. This is what the kernel interacts with. For example,
> +    if the AFU needs to read a particular virtual address, it sends
> +    that address to the PSL, the PSL then translates it, fetches the
> +    data from memory and returns it to the AFU. If the PSL has a
> +    translation miss, it interrupts the kernel and the kernel services
> +    the fault. The context to which this fault is serviced is based
> +    on who owns that acceleration function.
> +
> +AFU Models
> +==========
> +
> +    There are two programming models supported by the AFU. Dedicated
> +    and AFU directed. AFU may support one or both models.
> +
> +    In dedicated model only one MMU context is supported. In this

"In dedicated model" is a bit strange.

"When using the dedicated model .." ?

Or "dedicated mode" ?

> +    model, only one userspace process can use the accelerator at time.
> +
> +    In AFU directed model, up to 16K simultaneous contexts can be
> +    supported. This means up to 16K simultaneous userspace
> +    applications may use the accelerator (although specific AFUs may
> +    support less). In this mode, the AFU sends a 16 bit context ID

fewer not less :)

> +    with each of its requests. This tells the PSL which context is
> +    associated with this operation. If the PSL can't translate a

with each operation, or with an operation

> +    request, the ID can also be accessed by the kernel so it can
> +    determine the associated userspace context to service this
> +    translation with.

You were talking about operations but now it's translations?

Maybe "the ID can also be accessed by the kernel so it can determine the
userspace context associated with an operation".


> +MMIO space
> +==========
> +
> +    A portion of the FPGA MMIO space can be directly mapped from the
> +    AFU to userspace. Either the whole space can be mapped (master
> +    context), or just a per context portion (slave context). The
> +    hardware is self describing, hence the kernel can determine the
> +    offset and size of the per context portion.

That's the first mention of master and slave and it's not very clear.

> +
> +Interrupts
> +==========
> +
> +    AFUs may generate interrupts that are destined for userspace. These
> +    are received by the kernel as hardware interrupts and passed onto
> +    userspace.

How? (via read on the context ..)

> +    Data storage faults and error interrupts are handled by the kernel
> +    driver.
> +
> +Work Element Descriptor (WED)
> +=============================
> +
> +    The WED is a 64bit parameter passed to the AFU when a context is
> +    started. Its format is up to the AFU hence the kernel has no
> +    knowledge of what it represents. Typically it will be a virtual
> +    address pointer to a work queue where the AFU and userspace can

Effective address no?

> +    share control and status information or work queues.

"point to a work queue .. or work queues" doesn't read that well.

Maybe:

"Typically it will be the effective address of a work queue or status block
where the AFU and userspace can share control and status information."


> +User API
> +========
> +
> +    For AFUs operating in the AFU directed model, the driver will
> +    create two character devices per AFU under /dev/cxl. One for
> +    master and one for slave contexts.
> +
> +    The master context (eg. /dev/cxl/afu0.0m), has access to all of
> +    the MMIO space that an AFU provides. The slave context
> +    (eg. /dev/cxl/afu0.0) has access to only the per process MMIO
> +    space an AFU provides (AFU directed only).

There's only one slave context ?

> +    For AFUs operating in the dedicated process model, the driver will
> +    only create a single character device per AFU (e.g.
> +    /dev/cxl/afu0.0), which has access to the entire MMIO space that
> +    the AFU provides.
> +
> +    The following file operations are supported on both slave and
> +    master devices:
> +
> +    open
> +
> +        Opens the device and allocates a file descriptor to be used
> +        with the rest of the API.

This would be better done as a subsection I think, eg:

open
----

    Opens the device and allocates a file descriptor to be used
    with the rest of the API.

...

Otherwise you end up very indented further down.

> +
> +        A dedicated model AFU only has one context and hence only
> +        allows this device to be opened once.

Where do we enforce that?

> +        An AFU directed model AFU can have many contexts and hence
> +        this device can be opened by as many contexts as available.

What happens when all the contexts are opened?

> +        Note: IRQs also need to be allocated per context, which may
> +              also limit the number of contexts that can be allocated,
> +              and hence how many times the device may be opened. The
> +              POWER8 CAPP supports 2040 IRQs and 3 are used by the
> +              kernel, so 2037 are left. If 1 IRQ is needed per
> +              context, then only 2037 contexts can be allocated. If 4
> +              IRQs are needed per context, then only 2037/4 = 509
> +              contexts can be allocated.
> +
> +    ioctl
> +
> +        CXL_IOCTL_START_WORK:
> +            Starts the AFU context and associates it with the process
> +            memory. Once this ioctl is successfully executed, all

"the current process"

> +            memory mapped into this process is accessible to this AFU
> +            context using the same virtual addresses. No additional
> +            calls are required to map/unmap memory. The AFU memory
> +            context will be updated as userspace allocates and frees
> +            memory. This ioctl returns once the AFU context is
> +            started.
> +
> +            Takes a pointer to a struct cxl_ioctl_start_work
> +                    struct cxl_ioctl_start_work {
> +                            __u64 flags;
> +                            __u64 wed;
> +                            __u64 amr;
> +                            __s16 num_interrupts;
> +                            __s16 reserved1;
> +                            __s32 reserved2;
> +                            __u64 reserved3;
> +                            __u64 reserved4;
> +                            __u64 reserved5;
> +                            __u64 reserved6;
> +                    };
> +
> +                flags:
> +                    Indicates which optional fields (e.g. amr,
> +                    num_interrupts) in the structure are valid.

Don't mention the optional fields here, you'll just end up with a stale list
when you add more optional fields in future.

> +                wed:
> +                    The Work Element Descriptor (WED) is a 64bit
> +                    argument defined by the AFU. Typically this is an
> +                    virtual address pointing to an AFU specific
> +                    structure describing what work to perform.
> +
> +                amr:
> +                    Authority Mask Register (AMR), same as the powerpc
> +                    AMR.

Is it optional? How?

> +                num_interrupt:

plural.

> +                    Number of userspace interrupts to request. If not
> +                    specified the minimum number required will be
> +                    automatically allocated. The min and max number
> +                    can be obtained from sysfs.

Not specified how?

> +                reserved fields:
> +                    For ABI padding and future extensions
> +
> +        CXL_IOCTL_GET_PROCESS_ELEMENT:
> +            Get info on current context id. This info is returned
> +            from the kernel as an int.

It's not "info on the current context id", it *is* the id, isn't it ?

Any good reason it's an int and not a __u32 ?

> +            Written by the kernel with the context id (AKA process
> +            element) it has allocated. Slave contexts may want to
> +            communicate this to a master process.

I don't know what the implied noun for "Written" is. You could probably just
drop that sentence, you've said most of it already.

> +
> +    mmap
> +
> +        An AFU may have a MMIO space to facilitate communication with

an MMIO

> +        the AFU and mmap allows access to this. The size and contents

the AFU. If it does, the MMIO space can be accessed via mmap.

> +        of this area are specific to the particular AFU. The size can
> +        be discovered via sysfs.

What if there's none? Size of zero?

> +        In the AFU directed model, master contexts will get all of the

"get" is a bit vague. You mean master contexts will be allowed to map all of
the MMIO space?

> +        MMIO space and slave contexts will get only the per process
> +        space associated with its context. In the dedicated process
> +        model the entire MMIO space is always mapped.
> +
> +        This mmap call must be done after the IOCTL is started.

Which ioctl?

> +        Care should be taken when accessing MMIO space. Only 32 and
> +        64bit accesses are supported by POWER8. Also, the AFU will be
> +        designed with a specific endian, so all MMIO access should

endian*ness* ?

> +        consider endian (recommend endian(3) variants like: le64toh(),
> +        be64toh() etc). These endian issues equally apply to shared
> +        memory queues the WED may describe.
> +
> +    read
> +
> +        Reads an event from the AFU. Will return -EINVAL if the user

One or more events?

> +        supplied buffer to read into is less than 4096 bytes. 

You say that later so drop this one.

> +        Blocks
> +        if no events are pending (unless O_NONBLOCK is supplied). Will
> +        return -EIO in the case of an unrecoverable error or if the
> +        card is removed.

"Will return" -> "Returns"

> +        A read may return multiple events. A read will return the
> +        length of the buffer written and it will be a integral number
> +        of events up to the buffer size. 

That's a bit confusing, you're starting to rewrite the read(2) manpage, but
from the point of view of the kernel.

The actual text is "On success, the number of bytes read is returned".

I think you should just leave that as implied, because it's read(2). What you
do need to say is that the kernel will return an integral number of events.


> +        Users must supply a buffer size of at least 4K bytes.

"The buffer passed to read() must be at least 4K bytes".

> +
> +        All events will be return a struct cxl_event which varies in
> +        size.

"The result of the read will be a buffer of one or more events, each event is
of type struct cxl_event, of varying size."

> +                struct cxl_event {
> +                        struct cxl_event_header header;
> +                        union {
> +                                struct cxl_event_afu_interrupt irq;
> +                                struct cxl_event_data_storage fault;
> +                                struct cxl_event_afu_error afu_err;
> +                        };
> +                };
> +
> +        A struct cxl_event_header at the start gives:

"The struct cxl_event_header is defined as:"

> +                struct cxl_event_header {
> +                        __u16 type;
> +                        __u16 size;
> +                        __u16 process_element;
> +                        __u16 reserved1;
> +                };
> +
> +            type:
> +                This gives the type of event. The type determines how

s/gives/defines/

> +                the rest of the event will be structured. These types

s/will be/is/

> +                are shown below.

You don't mention cxl_event_type (the enum). You should.

> +
> +            size:
> +                This is the size of the event in bytes including the
> +                header. The start of the next event can be found at

s/header/struct cxl_event_header/

> +                this offset from the start of the current event.
> +
> +            process_element:
> +                Context ID of the event. 

>		   Currently this will always
> +                be the current context. Future work may allow
> +                interrupts from one context to be routed to another
> +                (eg. a master contexts handling error interrupts on
> +                behalf of a slave).

Drop all of that.

> +            reserved field:
> +                For future extensions and padding.
> +
> +        If an AFU interrupt event is received, the full structure received is:

"If the event type is CXL_EVENT_AFU_INTERRUPT then the event structure is defined as"

> +                struct cxl_event_afu_interrupt {
> +                        __u16 flags;
> +                        __u16 irq; /* Raised AFU interrupt number */
> +                        __u32 reserved1;
> +                };
> +
> +            flags:
> +                These flags indicate which optional fields are present
> +                in this struct. Currently all fields are Mandatory.

mandatory

> +            irq:
> +                The IRQ number sent by the AFU.
> +
> +            reserved field:
> +                For future extensions and padding.
> +
> +        If a data storage event is received, the full structure received is:

As for cxl_event_afu_interrupt.

> +                struct cxl_event_data_storage {
> +                        __u16 flags;
> +                        __u16 reserved1;
> +                        __u32 reserved2;
> +                        __u64 addr;
> +                        __u64 dsisr;
> +                        __u64 reserved3;
> +                };
> +
> +            flags:
> +                These flags indicate which optional fields are present
> +                in this struct. Currently all fields are Mandatory.

mandatory

> +            address: Mandatory

Drop the Mandatory.

> +                Address of the data storage trying to be accessed by

"The address that the AFU unsucessfully attempted to access"

> +                the AFU. Valid accesses will handled transparently by

will be handled

> +                the kernel but invalid access will generate this

invalid accesses

> +                event.
> +
> +            dsisr: Manditory

Drop Manditory.

> +                These fields give information on the type of

This field

> +                fault. Copy of the DSISR from PSL hardware when
> +                address fault occured.

Defined in CAIA ?

> +            reserved fields:
> +                For future extensions
> +
> +        If an AFU error event is received, the full structure received is:

As above.

> +                struct cxl_event_afu_error {
> +                        __u16 flags;
> +                        __u16 reserved1;
> +                        __u32 reserved2;
> +                        __u64 err;
> +                };
> +
> +            flags: Mandatory

Drop Mandatory.

> +                These flags indicate which optional fields are present
> +                in this struct. Currently all fields are Mandatory.
> +
> +            err:

Can we just call it error ?

> +                Error status from the AFU. AFU defined.

"Defined by the AFU".

> +            reserved fields:
> +                For future extensions and padding
> +
> +Sysfs Class
> +===========
> +
> +    A cxl sysfs class is added under /sys/class/cxl to facilitate
> +    enumeration and tuning of the accelerators. Its layout is
> +    described in Documentation/ABI/testing/sysfs-class-cxl
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 809ecd6..c972be3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2711,6 +2711,13 @@ W:	http://www.chelsio.com
>  S:	Supported
>  F:	drivers/net/ethernet/chelsio/cxgb4vf/
>  
> +CXL (IBM Coherent Accelerator Processor Interface CAPI) DRIVER
> +M:	Ian Munsie <imunsie@au1.ibm.com>
> +M:	Michael Neuling <mikey@neuling.org>
> +L:	linuxppc-dev@lists.ozlabs.org
> +S:	Supported
> +F:	drivers/misc/cxl/

F:	include/misc/cxl.h
F:	include/uapi/misc/cxl.h
F:	Documentation/powerpc/cxl.txt
F:	Documentation/powerpc/cxl.txt
F:	Documentation/ABI/testing/sysfs-class-cxl


cheers
