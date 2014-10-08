Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaJHI7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:59:17 -0400
Received: from ozlabs.org ([103.22.144.67]:53410 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbaJHIzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:55:36 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v4 16/16] cxl: Add documentation for userspace APIs
Date: Wed,  8 Oct 2014 19:55:05 +1100
Message-Id: <1412758505-23495-17-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412758505-23495-1-git-send-email-mikey@neuling.org>
References: <1412758505-23495-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This documentation gives an overview of the hardware architecture, userspace
APIs via /dev/cxl/afuM.N and the syfs files. It also adds a MAINTAINERS file
entry for cxl.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 Documentation/ABI/testing/sysfs-class-cxl | 130 ++++++++++
 Documentation/ioctl/ioctl-number.txt      |   1 +
 Documentation/powerpc/00-INDEX            |   2 +
 Documentation/powerpc/cxl.txt             | 379 ++++++++++++++++++++++++++++++
 MAINTAINERS                               |  12 +
 include/uapi/misc/cxl.h                   |   7 +-
 6 files changed, 528 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-cxl
 create mode 100644 Documentation/powerpc/cxl.txt

diff --git a/Documentation/ABI/testing/sysfs-class-cxl b/Documentation/ABI/testing/sysfs-class-cxl
new file mode 100644
index 0000000..0a5508c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-cxl
@@ -0,0 +1,130 @@
+Slave contexts (eg. /sys/class/cxl/afu0.0s):
+
+What:           /sys/class/cxl/<afu>/irqs_max
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read/write
+                Decimal value of maximum number of interrupts that can be
+                requested by userspace.  The default on probe is the maximum
+                that hardware can support (eg. 2037). Write values will limit
+                userspace applications to that many userspace interrupts. Must
+                be >= irqs_min.
+
+What:           /sys/class/cxl/<afu>/irqs_min
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Decimal value of the minimum number of interrupts that
+                userspace must request on a CXL_START_WORK ioctl. Userspace may
+                omit the num_interrupts field in the START_WORK IOCTL to get
+                this minimum automatically.
+
+What:           /sys/class/cxl/<afu>/mmio_size
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Decimal value of the size of the MMIO space that may be mmaped
+                by userspace.
+
+What:           /sys/class/cxl/<afu>/modes_supported
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                List of the modes this AFU supports. One per line.
+                Valid entries are: "dedicated_process" and "afu_directed"
+
+What:           /sys/class/cxl/<afu>/mode
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read/write
+                The current mode the AFU is using. Will be one of the modes
+                given in modes_supported. Writing will change the mode
+                provided that no user contexts are attached.
+
+
+What:           /sys/class/cxl/<afu>/prefault_mode
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read/write
+                Set the mode for prefaulting in segments into the segment table
+                when performing the START_WORK ioctl. Possible values:
+                        none: No prefaulting (default)
+                        work_element_descriptor: Treat the work element
+                                 descriptor as an effective address and
+                                 prefault what it points to.
+                        all: all segments process calling START_WORK maps.
+
+What:           /sys/class/cxl/<afu>/reset
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    write only
+                Writing 1 here will reset the AFU provided there are not
+                contexts active on the AFU.
+
+What:           /sys/class/cxl/<afu>/api_version
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Decimal value of the current version of the kernel/user API.
+
+What:           /sys/class/cxl/<afu>/api_version_com
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Decimal value of the the lowest version of the userspace API
+                this this kernel supports.
+
+
+
+Master contexts (eg. /sys/class/cxl/afu0.0m)
+
+What:           /sys/class/cxl/<afu>m/mmio_size
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Decimal value of the size of the MMIO space that may be mmaped
+                by userspace. This includes all slave contexts space also.
+
+What:           /sys/class/cxl/<afu>m/pp_mmio_len
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Decimal value of the Per Process MMIO space length.
+
+What:           /sys/class/cxl/<afu>m/pp_mmio_off
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Decimal value of the Per Process MMIO space offset.
+
+
+Card info (eg. /sys/class/cxl/card0)
+
+What:           /sys/class/cxl/<card>/caia_version
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Identifies the CAIA Version the card implements.
+
+What:           /sys/class/cxl/<card>/psl_version
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Identifies the revision level of the PSL.
+
+What:           /sys/class/cxl/<card>/base_image
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Identifies the revision level of the base image for devices
+                that support loadable PSLs. For FPGAs this field identifies
+                the image contained in the on-adapter flash which is loaded
+                during the initial program load.
+
+What:           /sys/class/cxl/<card>/image_loaded
+Date:           September 2014
+Contact:        linuxppc-dev@lists.ozlabs.org
+Description:    read only
+                Will return "user" or "factory" depending on the image loaded
+                onto the card.
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
index a68784d..6fd0e8b 100644
--- a/Documentation/powerpc/00-INDEX
+++ b/Documentation/powerpc/00-INDEX
@@ -11,6 +11,8 @@ bootwrapper.txt
 cpu_features.txt
 	- info on how we support a variety of CPUs with minimal compile-time
 	options.
+cxl.txt
+	- Overview of the CXL driver.
 eeh-pci-error-recovery.txt
 	- info on PCI Bus EEH Error Recovery
 firmware-assisted-dump.txt
diff --git a/Documentation/powerpc/cxl.txt b/Documentation/powerpc/cxl.txt
new file mode 100644
index 0000000..2c71ecc
--- /dev/null
+++ b/Documentation/powerpc/cxl.txt
@@ -0,0 +1,379 @@
+Coherent Accelerator Interface (CXL)
+====================================
+
+Introduction
+============
+
+    The coherent accelerator interface is designed to allow the
+    coherent connection of accelerators (FPGAs and other devices) to a
+    POWER system. These devices need to adhere to the Coherent
+    Accelerator Interface Architecture (CAIA).
+
+    IBM refers to this as the Coherent Accelerator Processor Interface
+    or CAPI. In the kernel it's referred to by the name CXL to avoid
+    confusion with the ISDN CAPI subsystem.
+
+    Coherent in this context means that the accelerator and CPUs can
+    both access system memory directly and with the same effective
+    addresses.
+
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
+       |   PHB    |        |         |
+       |   +------+        |   PSL   |
+       |   | CAPP |<------>|         |
+       +---+------+  PCIE  +---------+
+
+    The POWER8 chip has a Coherently Attached Processor Proxy (CAPP)
+    unit which is part of the PCIe Host Bridge (PHB). This is managed
+    by Linux by calls into OPAL. Linux doesn't directly program the
+    CAPP.
+
+    The FPGA (or coherently attached device) consists of two parts.
+    The POWER Service Layer (PSL) and the Accelerator Function Unit
+    (AFU). The AFU is used to implement specific functionality behind
+    the PSL. The PSL, among other things, provides memory address
+    translation services to allow each AFU direct access to userspace
+    memory.
+
+    The AFU is the core part of the accelerator (eg. the compression,
+    crypto etc function). The kernel has no knowledge of the function
+    of the AFU. Only userspace interacts directly with the AFU.
+
+    The PSL provides the translation and interrupt services that the
+    AFU needs. This is what the kernel interacts with. For example, if
+    the AFU needs to read a particular effective address, it sends
+    that address to the PSL, the PSL then translates it, fetches the
+    data from memory and returns it to the AFU. If the PSL has a
+    translation miss, it interrupts the kernel and the kernel services
+    the fault. The context to which this fault is serviced is based on
+    who owns that acceleration function.
+
+
+AFU Modes
+=========
+
+    There are two programming modes supported by the AFU. Dedicated
+    and AFU directed. AFU may support one or both modes.
+
+    When using dedicated mode only one MMU context is supported. In
+    this mode, only one userspace process can use the accelerator at
+    time.
+
+    When using AFU directed mode, up to 16K simultaneous contexts can
+    be supported. This means up to 16K simultaneous userspace
+    applications may use the accelerator (although specific AFUs may
+    support fewer). In this mode, the AFU sends a 16 bit context ID
+    with each of its requests. This tells the PSL which context is
+    associated with each operation. If the PSL can't translate an
+    operation, the ID can also be accessed by the kernel so it can
+    determine the userspace context associated with an operation.
+
+
+MMIO space
+==========
+
+    A portion of the accelerator MMIO space can be directly mapped
+    from the AFU to userspace. Either the whole space can be mapped or
+    just a per context portion. The hardware is self describing, hence
+    the kernel can determine the offset and size of the per context
+    portion.
+
+
+Interrupts
+==========
+
+    AFUs may generate interrupts that are destined for userspace. These
+    are received by the kernel as hardware interrupts and passed onto
+    userspace by a read syscall documented below.
+
+    Data storage faults and error interrupts are handled by the kernel
+    driver.
+
+
+Work Element Descriptor (WED)
+=============================
+
+    The WED is a 64-bit parameter passed to the AFU when a context is
+    started. Its format is up to the AFU hence the kernel has no
+    knowledge of what it represents. Typically it will be the
+    effective address of a work queue or status block where the AFU
+    and userspace can share control and status information.
+
+
+
+
+User API
+========
+
+    For AFUs operating in AFU directed mode, two character device
+    files will be created. /dev/cxl/afu0.0m will correspond to a
+    master context and /dev/cxl/afu0.0s will correspond to a slave
+    context. Master contexts have access to the full MMIO space an
+    AFU provides. Slave contexts have access to only the per process
+    MMIO space an AFU provides.
+
+    For AFUs operating in dedicated process mode, the driver will
+    only create a single character device per AFU called
+    /dev/cxl/afu0.0d. This will have access to the entire MMIO space
+    that the AFU provides (like master contexts in AFU directed).
+
+    The types described below are defined in include/uapi/misc/cxl.h
+
+    The following file operations are supported on both slave and
+    master devices.
+
+
+open
+----
+
+    Opens the device and allocates a file descriptor to be used with
+    the rest of the API.
+
+    A dedicated mode AFU only has one context and only allows the
+    device to be opened once.
+
+    An AFU directed mode AFU can have many contexts, the device can be
+    opened once for each context that is available.
+
+    When all available contexts are allocated the open call will fail
+    and return -ENOSPC.
+
+    Note: IRQs need to be allocated for each context, which may limit
+          the number of contexts that can be created, and therefore
+          how many times the device can be opened. The POWER8 CAPP
+          supports 2040 IRQs and 3 are used by the kernel, so 2037 are
+          left. If 1 IRQ is needed per context, then only 2037
+          contexts can be allocated. If 4 IRQs are needed per context,
+          then only 2037/4 = 509 contexts can be allocated.
+
+
+ioctl
+-----
+
+    CXL_IOCTL_START_WORK:
+        Starts the AFU context and associates it with the current
+        process. Once this ioctl is successfully executed, all memory
+        mapped into this process is accessible to this AFU context
+        using the same effective addresses. No additional calls are
+        required to map/unmap memory. The AFU memory context will be
+        updated as userspace allocates and frees memory. This ioctl
+        returns once the AFU context is started.
+
+        Takes a pointer to a struct cxl_ioctl_start_work:
+
+                struct cxl_ioctl_start_work {
+                        __u64 flags;
+                        __u64 work_element_descriptor;
+                        __u64 amr;
+                        __s16 num_interrupts;
+                        __s16 reserved1;
+                        __s32 reserved2;
+                        __u64 reserved3;
+                        __u64 reserved4;
+                        __u64 reserved5;
+                        __u64 reserved6;
+                };
+
+            flags:
+                Indicates which optional fields in the structure are
+                valid.
+
+            work_element_descriptor:
+                The Work Element Descriptor (WED) is a 64-bit argument
+                defined by the AFU. Typically this is an effective
+                address pointing to an AFU specific structure
+                describing what work to perform.
+
+            amr:
+                Authority Mask Register (AMR), same as the powerpc
+                AMR. This field is only used by the kernel when the
+                corresponding CXL_START_WORK_AMR value is specified in
+                flags. If not specified the kernel will use a default
+                value of 0.
+
+            num_interrupts:
+                Number of userspace interrupts to request. This field
+                is only used by the kernel when the corresponding
+                CXL_START_WORK_NUM_IRQS value is specified in flags.
+                If not specified the minimum number required by the
+                AFU will be allocated. The min and max number can be
+                obtained from sysfs.
+
+            reserved fields:
+                For ABI padding and future extensions
+
+    CXL_IOCTL_GET_PROCESS_ELEMENT:
+        Get the current context id, also known as the process element.
+        The value is returned from the kernel as a __u32.
+
+
+mmap
+----
+
+    An AFU may have an MMIO space to facilitate communication with the
+    AFU. If it does, the MMIO space can be accessed via mmap. The size
+    and contents of this area are specific to the particular AFU. The
+    size can be discovered via sysfs.
+
+    In AFU directed mode, master contexts are allowed to map all of
+    the MMIO space and slave contexts are allowed to only map the per
+    process MMIO space associated with the context. In dedicated
+    process mode the entire MMIO space can always be mapped.
+
+    This mmap call must be done after the START_WORK ioctl.
+
+    Care should be taken when accessing MMIO space. Only 32 and 64-bit
+    accesses are supported by POWER8. Also, the AFU will be designed
+    with a specific endianness, so all MMIO accesses should consider
+    endianness (recommend endian(3) variants like: le64toh(),
+    be64toh() etc). These endian issues equally apply to shared memory
+    queues the WED may describe.
+
+
+read
+----
+
+    Reads events from the AFU. Blocks if no events are pending
+    (unless O_NONBLOCK is supplied). Returns -EIO in the case of an
+    unrecoverable error or if the card is removed.
+
+    read() will always return an integral number of events.
+
+    The buffer passed to read() must be at least 4K bytes.
+
+    The result of the read will be a buffer of one or more events,
+    each event is of type struct cxl_event, of varying size.
+
+            struct cxl_event {
+                    struct cxl_event_header header;
+                    union {
+                            struct cxl_event_afu_interrupt irq;
+                            struct cxl_event_data_storage fault;
+                            struct cxl_event_afu_error afu_error;
+                    };
+            };
+
+    The struct cxl_event_header is defined as:
+
+            struct cxl_event_header {
+                    __u16 type;
+                    __u16 size;
+                    __u16 process_element;
+                    __u16 reserved1;
+            };
+
+        type:
+            This defines the type of event. The type determines how
+            the rest of the event is structured. These types are
+            described below and defined by enum cxl_event_type.
+
+        size:
+            This is the size of the event in bytes including the
+            struct cxl_event_header. The start of the next event can
+            be found at this offset from the start of the current
+            event.
+
+        process_element:
+            Context ID of the event.
+
+        reserved field:
+            For future extensions and padding.
+
+    If the event type is CXL_EVENT_AFU_INTERRUPT then the event
+    structure is defined as:
+
+            struct cxl_event_afu_interrupt {
+                    __u16 flags;
+                    __u16 irq; /* Raised AFU interrupt number */
+                    __u32 reserved1;
+            };
+
+        flags:
+            These flags indicate which optional fields are present
+            in this struct. Currently all fields are mandatory.
+
+        irq:
+            The IRQ number sent by the AFU.
+
+        reserved field:
+            For future extensions and padding.
+
+    If the event type is CXL_EVENT_DATA_STORAGE then the event
+    structure is defined as:
+
+            struct cxl_event_data_storage {
+                    __u16 flags;
+                    __u16 reserved1;
+                    __u32 reserved2;
+                    __u64 addr;
+                    __u64 dsisr;
+                    __u64 reserved3;
+            };
+
+        flags:
+            These flags indicate which optional fields are present in
+            this struct. Currently all fields are mandatory.
+
+        address:
+            The address that the AFU unsuccessfully attempted to
+            access. Valid accesses will be handled transparently by the
+            kernel but invalid accesses will generate this event.
+
+        dsisr:
+            This field gives information on the type of fault. It is a
+            copy of the DSISR from the PSL hardware when the address
+            fault occurred. The form of the DSISR is as defined in the
+            CAIA.
+
+        reserved fields:
+            For future extensions
+
+    If the event type is CXL_EVENT_AFU_ERROR then the event structure
+    is defined as:
+
+            struct cxl_event_afu_error {
+                    __u16 flags;
+                    __u16 reserved1;
+                    __u32 reserved2;
+                    __u64 error;
+            };
+
+        flags:
+            These flags indicate which optional fields are present in
+            this struct. Currently all fields are Mandatory.
+
+        error:
+            Error status from the AFU. Defined by the AFU.
+
+        reserved fields:
+            For future extensions and padding
+
+Sysfs Class
+===========
+
+    A cxl sysfs class is added under /sys/class/cxl to facilitate
+    enumeration and tuning of the accelerators. Its layout is
+    described in Documentation/ABI/testing/sysfs-class-cxl
+
+Udev rules
+==========
+
+    The following udev rules could be used to create a symlink to the
+    most logical chardev to use in any programming mode (afuX.Yd for
+    dedicated, afuX.Ys for afu directed), since the API is virtually
+    identical for each:
+
+	SUBSYSTEM=="cxl", ATTRS{mode}=="dedicated_process", SYMLINK="cxl/%b"
+	SUBSYSTEM=="cxl", ATTRS{mode}=="afu_directed", \
+	                  KERNEL=="afu[0-9]*.[0-9]*s", SYMLINK="cxl/%b"
diff --git a/MAINTAINERS b/MAINTAINERS
index 809ecd6..facc219 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2711,6 +2711,18 @@ W:	http://www.chelsio.com
 S:	Supported
 F:	drivers/net/ethernet/chelsio/cxgb4vf/
 
+CXL (IBM Coherent Accelerator Processor Interface CAPI) DRIVER
+M:	Ian Munsie <imunsie@au1.ibm.com>
+M:	Michael Neuling <mikey@neuling.org>
+L:	linuxppc-dev@lists.ozlabs.org
+S:	Supported
+F:	drivers/misc/cxl/
+F:	include/misc/cxl.h
+F:	include/uapi/misc/cxl.h
+F:	Documentation/powerpc/cxl.txt
+F:	Documentation/powerpc/cxl.txt
+F:	Documentation/ABI/testing/sysfs-class-cxl
+
 STMMAC ETHERNET DRIVER
 M:	Giuseppe Cavallaro <peppe.cavallaro@st.com>
 L:	netdev@vger.kernel.org
diff --git a/include/uapi/misc/cxl.h b/include/uapi/misc/cxl.h
index c232be6..cd6d789 100644
--- a/include/uapi/misc/cxl.h
+++ b/include/uapi/misc/cxl.h
@@ -13,7 +13,7 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
-/* Structs for IOCTLS for userspace to talk to the kernel */
+
 struct cxl_ioctl_start_work {
 	__u64 flags;
 	__u64 work_element_descriptor;
@@ -26,19 +26,20 @@ struct cxl_ioctl_start_work {
 	__u64 reserved5;
 	__u64 reserved6;
 };
+
 #define CXL_START_WORK_AMR		0x0000000000000001ULL
 #define CXL_START_WORK_NUM_IRQS		0x0000000000000002ULL
 #define CXL_START_WORK_ALL		(CXL_START_WORK_AMR |\
 					 CXL_START_WORK_NUM_IRQS)
 
-/* IOCTL numbers */
+/* ioctl numbers */
 #define CXL_MAGIC 0xCA
 #define CXL_IOCTL_START_WORK		_IOW(CXL_MAGIC, 0x00, struct cxl_ioctl_start_work)
 #define CXL_IOCTL_GET_PROCESS_ELEMENT	_IOR(CXL_MAGIC, 0x01, __u32)
 
-/* Events from read() */
 #define CXL_READ_MIN_SIZE 0x1000 /* 4K */
 
+/* Events from read() */
 enum cxl_event_type {
 	CXL_EVENT_RESERVED      = 0,
 	CXL_EVENT_AFU_INTERRUPT = 1,
-- 
1.9.1

