Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaJGKuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:50:16 -0400
Received: from ozlabs.org ([103.22.144.67]:40961 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbaJGKto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:49:44 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v3 16/16] cxl: Add documentation for userspace APIs
Date: Tue,  7 Oct 2014 21:48:22 +1100
Message-Id: <1412678902-18672-17-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412678902-18672-1-git-send-email-mikey@neuling.org>
References: <1412678902-18672-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This documentation gives an overview of the hardware architecture, userspace
APIs via /dev/cxl/afu0.0 and the syfs files. It also adds a MAINTAINERS file
entry for cxl.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 Documentation/ABI/testing/sysfs-class-cxl | 142 ++++++++++++
 Documentation/ioctl/ioctl-number.txt      |   1 +
 Documentation/powerpc/00-INDEX            |   2 +
 Documentation/powerpc/cxl.txt             | 346 ++++++++++++++++++++++++++++++
 MAINTAINERS                               |   7 +
 5 files changed, 498 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-cxl
 create mode 100644 Documentation/powerpc/cxl.txt

diff --git a/Documentation/ABI/testing/sysfs-class-cxl b/Documentation/ABI/testing/sysfs-class-cxl
new file mode 100644
index 0000000..ca429fc
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-cxl
@@ -0,0 +1,142 @@
+Slave contexts (eg. /sys/class/cxl/afu0.0):
+
+What:		/sys/class/cxl/<afu>/irqs_max
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		Maximum number of interrupts that can be requested by userspace.
+		The default on probe is the maximum that hardware can support
+		(eg. 2037). Write values will limit userspace applications to
+		that many userspace interrupts. Must be >= irqs_min.
+
+What:		/sys/class/cxl/<afu>/irqs_min
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		The minimum number of interrupts that userspace must request
+		on a CXL_START_WORK ioctl. Userspace may omit the
+		num_interrupts field in the START_WORK IOCTL to get this
+		minimum automatically.
+
+What:		/sys/class/cxl/<afu>/mmio_size
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		Size of the MMIO space that may be mmaped by userspace.
+
+
+What:		/sys/class/cxl/<afu>/models_supported
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		List of the models this AFU supports.
+		Valid entries are: "dedicated_process" and "afu_directed"
+
+What:		/sys/class/cxl/<afu>/model
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read/write
+		The current model the AFU is using. Will be one of the models
+		given in models_supported. Writing will change the model
+		provided that no user contexts are attached.
+
+
+What:		/sys/class/cxl/<afu>/prefault_mode
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read/write
+		Set the mode for prefaulting in segments into the segment table
+		when performing the START_WORK ioctl. Possible values:
+			none: No prefaulting (default)
+			wed: Treat the wed as an effective address and prefault it
+			all: all segments this process currently maps
+
+What:		/sys/class/cxl/<afu>/reset
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	write only
+		Reset the AFU.
+
+What:		/sys/class/cxl/<afu>/api_version
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		List the current version of the kernel/user API.
+
+What:		/sys/class/cxl/<afu>/api_version_com
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		List the lowest version the kernel/user API this
+		kernel is compatible with.
+
+
+
+Master contexts (eg. /sys/class/cxl/afu0.0m)
+
+What:		/sys/class/cxl/<afu>m/mmio_size
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		Size of the MMIO space that may be mmaped by userspace. This
+		includes all slave contexts space also.
+
+What:		/sys/class/cxl/<afu>m/pp_mmio_len
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		Per Process MMIO space length.
+
+What:		/sys/class/cxl/<afu>m/pp_mmio_off
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		Per Process MMIO space offset.
+
+
+Card info (eg. /sys/class/cxl/card0)
+
+What:		/sys/class/cxl/<card>/caia_version
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		Identifies the CAIA Version the card implements.
+
+What:		/sys/class/cxl/<card>/psl_version
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		Identifies the revision level of the PSL.
+
+What:		/sys/class/cxl/<card>/base_image
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		Identifies the revision level of the base image for devices
+		that support load-able PSLs. For FPGAs this field identifies
+		the image contained in the on-adapter flash which is loaded
+		during the initial program load
+
+What:		/sys/class/cxl/<card>/image_loaded
+Date:		September 2014
+Contact:	Ian Munsie <imunsie@au1.ibm.com>,
+		Michael Neuling <mikey@neuling.org>
+Description:	read only
+		Will return "user" or "factory" depending on the image loaded
+		onto the card
+
diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 7e240a7..8136e1f 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -313,6 +313,7 @@ Code  Seq#(hex)	Include File		Comments
 0xB1	00-1F	PPPoX			<mailto:mostrows@styx.uwaterloo.ca>
 0xB3	00	linux/mmc/ioctl.h
 0xC0	00-0F	linux/usb/iowarrior.h
+0xCA	00-0F	uapi/misc/cxl.h
 0xCB	00-1F	CBM serial IEC bus	in development:
 					<mailto:michael.klein@puffin.lb.shuttle.de>
 0xCD	01	linux/reiserfs_fs.h
diff --git a/Documentation/powerpc/00-INDEX b/Documentation/powerpc/00-INDEX
index a68784d..116d94d 100644
--- a/Documentation/powerpc/00-INDEX
+++ b/Documentation/powerpc/00-INDEX
@@ -28,3 +28,5 @@ ptrace.txt
 	- Information on the ptrace interfaces for hardware debug registers.
 transactional_memory.txt
 	- Overview of the Power8 transactional memory support.
+cxl.txt
+	- Overview of the CXL driver.
diff --git a/Documentation/powerpc/cxl.txt b/Documentation/powerpc/cxl.txt
new file mode 100644
index 0000000..36f7ba4
--- /dev/null
+++ b/Documentation/powerpc/cxl.txt
@@ -0,0 +1,346 @@
+Coherent Accelerator Interface (CXL)
+====================================
+
+Introduction
+============
+
+    The coherent accelerator interface is designed to allow the
+    coherent connection of FPGA based accelerators (and other devices)
+    to a POWER system. These devices need to adhere to the Coherent
+    Accelerator Interface Architecture (CAIA).
+
+    IBM refers to this as the Coherent Accelerator Processor Interface
+    or CAPI. In the kernel it's referred to by the name CXL to avoid
+    confusion with the ISDN CAPI subsystem.
+
+Hardware overview
+=================
+
+          POWER8               FPGA
+       +----------+        +---------+
+       |          |        |         |
+       |   CPU    |        |   AFU   |
+       |          |        |         |
+       |          |        |         |
+       |          |        |         |
+       +----------+        +---------+
+       |          |        |         |
+       |   CAPP   +--------+   PSL   |
+       |          |  PCIe  |         |
+       +----------+        +---------+
+
+    The POWER8 chip has a Coherently Attached Processor Proxy (CAPP)
+    unit which is part of the PCIe Host Bridge (PHB). This is managed
+    by Linux by calls into OPAL. Linux doesn't directly program the
+    CAPP.
+
+    The FPGA (or coherently attached device) consists of two parts.
+    The POWER Service Layer (PSL) and the Accelerator Function Unit
+    (AFU). AFU is used to implement specific functionality behind
+    the PSL. The PSL, among other things, provides memory address
+    translation services to allow each AFU direct access to userspace
+    memory.
+
+    The AFU is the core part of the accelerator (eg. the compression,
+    crypto etc function). The kernel has no knowledge of the function
+    of the AFU. Only userspace interacts directly with the AFU.
+
+    The PSL provides the translation and interrupt services that the
+    AFU needs. This is what the kernel interacts with. For example,
+    if the AFU needs to read a particular virtual address, it sends
+    that address to the PSL, the PSL then translates it, fetches the
+    data from memory and returns it to the AFU. If the PSL has a
+    translation miss, it interrupts the kernel and the kernel services
+    the fault. The context to which this fault is serviced is based
+    on who owns that acceleration function.
+
+AFU Models
+==========
+
+    There are two programming models supported by the AFU. Dedicated
+    and AFU directed. AFU may support one or both models.
+
+    In dedicated model only one MMU context is supported. In this
+    model, only one userspace process can use the accelerator at time.
+
+    In AFU directed model, up to 16K simultaneous contexts can be
+    supported. This means up to 16K simultaneous userspace
+    applications may use the accelerator (although specific AFUs may
+    support less). In this mode, the AFU sends a 16 bit context ID
+    with each of its requests. This tells the PSL which context is
+    associated with this operation. If the PSL can't translate a
+    request, the ID can also be accessed by the kernel so it can
+    determine the associated userspace context to service this
+    translation with.
+
+MMIO space
+==========
+
+    A portion of the FPGA MMIO space can be directly mapped from the
+    AFU to userspace. Either the whole space can be mapped (master
+    context), or just a per context portion (slave context). The
+    hardware is self describing, hence the kernel can determine the
+    offset and size of the per context portion.
+
+Interrupts
+==========
+
+    AFUs may generate interrupts that are destined for userspace. These
+    are received by the kernel as hardware interrupts and passed onto
+    userspace.
+
+    Data storage faults and error interrupts are handled by the kernel
+    driver.
+
+Work Element Descriptor (WED)
+=============================
+
+    The WED is a 64bit parameter passed to the AFU when a context is
+    started. Its format is up to the AFU hence the kernel has no
+    knowledge of what it represents. Typically it will be a virtual
+    address pointer to a work queue where the AFU and userspace can
+    share control and status information or work queues.
+
+
+
+
+User API
+========
+
+    For AFUs operating in the AFU directed model, the driver will
+    create two character devices per AFU under /dev/cxl. One for
+    master and one for slave contexts.
+
+    The master context (eg. /dev/cxl/afu0.0m), has access to all of
+    the MMIO space that an AFU provides. The slave context
+    (eg. /dev/cxl/afu0.0) has access to only the per process MMIO
+    space an AFU provides (AFU directed only).
+
+    For AFUs operating in the dedicated process model, the driver will
+    only create a single character device per AFU (e.g.
+    /dev/cxl/afu0.0), which has access to the entire MMIO space that
+    the AFU provides.
+
+    The following file operations are supported on both slave and
+    master devices:
+
+    open
+
+        Opens the device and allocates a file descriptor to be used
+        with the rest of the API.
+
+        A dedicated model AFU only has one context and hence only
+        allows this device to be opened once.
+
+        An AFU directed model AFU can have many contexts and hence
+        this device can be opened by as many contexts as available.
+
+        Note: IRQs also need to be allocated per context, which may
+              also limit the number of contexts that can be allocated,
+              and hence how many times the device may be opened. The
+              POWER8 CAPP supports 2040 IRQs and 3 are used by the
+              kernel, so 2037 are left. If 1 IRQ is needed per
+              context, then only 2037 contexts can be allocated. If 4
+              IRQs are needed per context, then only 2037/4 = 509
+              contexts can be allocated.
+
+    ioctl
+
+        CXL_IOCTL_START_WORK:
+            Starts the AFU context and associates it with the process
+            memory. Once this ioctl is successfully executed, all
+            memory mapped into this process is accessible to this AFU
+            context using the same virtual addresses. No additional
+            calls are required to map/unmap memory. The AFU memory
+            context will be updated as userspace allocates and frees
+            memory. This ioctl returns once the AFU context is
+            started.
+
+            Takes a pointer to a struct cxl_ioctl_start_work
+                    struct cxl_ioctl_start_work {
+                            __u64 flags;
+                            __u64 wed;
+                            __u64 amr;
+                            __s16 num_interrupts;
+                            __s16 reserved1;
+                            __s32 reserved2;
+                            __u64 reserved3;
+                            __u64 reserved4;
+                            __u64 reserved5;
+                            __u64 reserved6;
+                    };
+
+                flags:
+                    Indicates which optional fields (e.g. amr,
+                    num_interrupts) in the structure are valid.
+
+                wed:
+                    The Work Element Descriptor (WED) is a 64bit
+                    argument defined by the AFU. Typically this is an
+                    virtual address pointing to an AFU specific
+                    structure describing what work to perform.
+
+                amr:
+                    Authority Mask Register (AMR), same as the powerpc
+                    AMR.
+
+                num_interrupt:
+                    Number of userspace interrupts to request. If not
+                    specified the minimum number required will be
+                    automatically allocated. The min and max number
+                    can be obtained from sysfs.
+
+                reserved fields:
+                    For ABI padding and future extensions
+
+        CXL_IOCTL_GET_PROCESS_ELEMENT:
+            Get info on current context id. This info is returned
+            from the kernel as an int.
+
+            Written by the kernel with the context id (AKA process
+            element) it has allocated. Slave contexts may want to
+            communicate this to a master process.
+
+    mmap
+
+        An AFU may have a MMIO space to facilitate communication with
+        the AFU and mmap allows access to this. The size and contents
+        of this area are specific to the particular AFU. The size can
+        be discovered via sysfs.
+
+        In the AFU directed model, master contexts will get all of the
+        MMIO space and slave contexts will get only the per process
+        space associated with its context. In the dedicated process
+        model the entire MMIO space is always mapped.
+
+        This mmap call must be done after the IOCTL is started.
+
+        Care should be taken when accessing MMIO space. Only 32 and
+        64bit accesses are supported by POWER8. Also, the AFU will be
+        designed with a specific endian, so all MMIO access should
+        consider endian (recommend endian(3) variants like: le64toh(),
+        be64toh() etc). These endian issues equally apply to shared
+        memory queues the WED may describe.
+
+    read
+
+        Reads an event from the AFU. Will return -EINVAL if the user
+        supplied buffer to read into is less than 4096 bytes. Blocks
+        if no events are pending (unless O_NONBLOCK is supplied). Will
+        return -EIO in the case of an unrecoverable error or if the
+        card is removed.
+
+        A read may return multiple events. A read will return the
+        length of the buffer written and it will be a integral number
+        of events up to the buffer size. Users must supply a buffer
+        size of at least 4K bytes.
+
+        All events will be return a struct cxl_event which varies in
+        size.
+
+                struct cxl_event {
+                        struct cxl_event_header header;
+                        union {
+                                struct cxl_event_afu_interrupt irq;
+                                struct cxl_event_data_storage fault;
+                                struct cxl_event_afu_error afu_err;
+                        };
+                };
+
+        A struct cxl_event_header at the start gives:
+                struct cxl_event_header {
+                        __u16 type;
+                        __u16 size;
+                        __u16 process_element;
+                        __u16 reserved1;
+                };
+
+            type:
+                This gives the type of event. The type determines how
+                the rest of the event will be structured. These types
+                are shown below.
+
+            size:
+                This is the size of the event in bytes including the
+                header. The start of the next event can be found at
+                this offset from the start of the current event.
+
+            process_element:
+                Context ID of the event. Currently this will always
+                be the current context. Future work may allow
+                interrupts from one context to be routed to another
+                (eg. a master contexts handling error interrupts on
+                behalf of a slave).
+
+            reserved field:
+                For future extensions and padding.
+
+        If an AFU interrupt event is received, the full structure received is:
+                struct cxl_event_afu_interrupt {
+                        __u16 flags;
+                        __u16 irq; /* Raised AFU interrupt number */
+                        __u32 reserved1;
+                };
+
+            flags:
+                These flags indicate which optional fields are present
+                in this struct. Currently all fields are Mandatory.
+
+            irq:
+                The IRQ number sent by the AFU.
+
+            reserved field:
+                For future extensions and padding.
+
+        If a data storage event is received, the full structure received is:
+                struct cxl_event_data_storage {
+                        __u16 flags;
+                        __u16 reserved1;
+                        __u32 reserved2;
+                        __u64 addr;
+                        __u64 dsisr;
+                        __u64 reserved3;
+                };
+
+            flags:
+                These flags indicate which optional fields are present
+                in this struct. Currently all fields are Mandatory.
+
+            address: Mandatory
+                Address of the data storage trying to be accessed by
+                the AFU. Valid accesses will handled transparently by
+                the kernel but invalid access will generate this
+                event.
+
+            dsisr: Manditory
+                These fields give information on the type of
+                fault. Copy of the DSISR from PSL hardware when
+                address fault occured.
+
+            reserved fields:
+                For future extensions
+
+        If an AFU error event is received, the full structure received is:
+                struct cxl_event_afu_error {
+                        __u16 flags;
+                        __u16 reserved1;
+                        __u32 reserved2;
+                        __u64 err;
+                };
+
+            flags: Mandatory
+                These flags indicate which optional fields are present
+                in this struct. Currently all fields are Mandatory.
+
+            err:
+                Error status from the AFU. AFU defined.
+
+            reserved fields:
+                For future extensions and padding
+
+Sysfs Class
+===========
+
+    A cxl sysfs class is added under /sys/class/cxl to facilitate
+    enumeration and tuning of the accelerators. Its layout is
+    described in Documentation/ABI/testing/sysfs-class-cxl
diff --git a/MAINTAINERS b/MAINTAINERS
index 809ecd6..c972be3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2711,6 +2711,13 @@ W:	http://www.chelsio.com
 S:	Supported
 F:	drivers/net/ethernet/chelsio/cxgb4vf/
 
+CXL (IBM Coherent Accelerator Processor Interface CAPI) DRIVER
+M:	Ian Munsie <imunsie@au1.ibm.com>
+M:	Michael Neuling <mikey@neuling.org>
+L:	linuxppc-dev@lists.ozlabs.org
+S:	Supported
+F:	drivers/misc/cxl/
+
 STMMAC ETHERNET DRIVER
 M:	Giuseppe Cavallaro <peppe.cavallaro@st.com>
 L:	netdev@vger.kernel.org
-- 
1.9.1

