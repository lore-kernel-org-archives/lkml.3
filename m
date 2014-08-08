Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaHHSUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:20:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55534 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaHHSUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:20:45 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <grant.likely@linaro.org>,
        <gregkh@linuxfoundation.org>, <galak@codeaurora.org>, <olof@lixom.net>,
        <mark.rutland@arm.com>, <devicetree@vger.kernel.org>, <arnd@arndb.de>,
        <sandeep_n@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: =?UTF-8?q?=5BPatch=20v3=202/6=5D=20Documentation=3A=20dt=3A=20soc=3A=20add=20Keystone=20Navigator=20QMSS=20bindings?=
Date: Fri, 8 Aug 2014 14:19:41 -0400
Message-ID: <1407521985-22574-3-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407521985-22574-1-git-send-email-santosh.shilimkar@ti.com>
References: <1407521985-22574-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sandeep Nair <sandeep_n@ti.com>

The QMSS (Queue Manager Sub System) found on Keystone SOCs is one of
the main hardware sub system which forms the backbone of the Keystone
Multi-core Navigator. QMSS consist of queue managers, packed-data structure
processors(PDSP), linking RAM, descriptor pools and infrastructure
Packet DMA.

The Queue Manager is a hardware module that is responsible for accelerating
management of the packet queues. Packets are queued/de-queued by writing or
reading descriptor address to a particular memory mapped location. The PDSPs
perform QMSS related functions like accumulation, QoS, or event management.
Linking RAM registers are used to link the descriptors which are stored in
descriptor RAM. Descriptor RAM is configurable as internal or external memory.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 .../bindings/soc/ti/keystone-navigator-qmss.txt    |  232 ++++++++++++++++++++
 1 file changed, 232 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/ti/keystone-navigator-qmss.txt

diff --git a/Documentation/devicetree/bindings/soc/ti/keystone-navigator-qmss.txt b/Documentation/devicetree/bindings/soc/ti/keystone-navigator-qmss.txt
new file mode 100644
index 0000000..d8e8cdb
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/ti/keystone-navigator-qmss.txt
@@ -0,0 +1,232 @@
+* Texas Instruments Keystone Navigator Queue Management SubSystem driver
+
+The QMSS (Queue Manager Sub System) found on Keystone SOCs is one of
+the main hardware sub system which forms the backbone of the Keystone
+multi-core Navigator. QMSS consist of queue managers, packed-data structure
+processors(PDSP), linking RAM, descriptor pools and infrastructure
+Packet DMA.
+The Queue Manager is a hardware module that is responsible for accelerating
+management of the packet queues. Packets are queued/de-queued by writing or
+reading descriptor address to a particular memory mapped location. The PDSPs
+perform QMSS related functions like accumulation, QoS, or event management.
+Linking RAM registers are used to link the descriptors which are stored in
+descriptor RAM. Descriptor RAM is configurable as internal or external memory.
+The QMSS driver manages the PDSP setups, linking RAM regions,
+queue pool management (allocation, push, pop and notify) and descriptor
+pool management.
+
+
+Required properties:
+- compatible	: Must be "ti,keystone-navigator-qmss";
+- clocks	: phandle to the reference clock for this device.
+- queue-range	: <start number> total range of queue numbers for the device.
+- linkram0	: <address size> for internal link ram, where size is the total
+		  link ram entries.
+- linkram1	: <address size> for external link ram, where size is the total
+		  external link ram entries. If the address is specified as "0"
+		  driver will allocate memory.
+- qmgrs         : child node describing the individual queue managers on the
+		  SoC. On keystone 1 devices there should be only one node.
+		  On keystone 2 devices there can be more than 1 node.
+  -- managed-queues	: the actual queues managed by each queue manager
+			  instance, specified as <"base queue #" "# of queues">.
+  -- reg		: Address and size of the register set for the device.
+			  Register regions should be specified in the following
+			  order
+			  - Queue Peek region.
+			  - Queue status RAM.
+			  - Queue configuration region.
+			  - Descriptor memory setup region.
+			  - Queue Management/Queue Proxy region for queue Push.
+			  - Queue Management/Queue Proxy region for queue Pop.
+- queue-pools	: child node classifying the queue ranges into pools.
+		  Queue ranges are grouped into 3 type of pools:
+		  - qpend	    : pool of qpend(interruptible) queues
+		  - general-purpose : pool of general queues, primarly used
+				      as free descriptor queues or the
+				      transmit DMA queues.
+		  - accumulator	    : pool of queues on PDSP accumulator channel
+		  Each range can have the following properties:
+  -- qrange		: number of queues to use per queue range, specified as
+			  <"base queue #" "# of queues">.
+  -- interrupts		: Optional property to specify the interrupt mapping
+			  for interruptible queues. The driver additionaly sets
+			  the interrupt affinity hint based on the cpu mask.
+  -- qalloc-by-id	: Optional property to specify that the queues in this
+			  range can only be allocated by queue id.
+  -- accumulator	: Accumulator channel specification. Any of the PDSPs in
+			  QMSS can be loaded with the accumulator firmware. The
+			  accumulator firmware’s job is to poll a select number of
+			  queues looking for descriptors that have been pushed
+			  into them. Descriptors are popped from the queue and
+			  placed in a buffer provided by the host. When the list
+			  becomes full or a programmed time period expires, the
+			  accumulator triggers an interrupt to the host to read
+			  the buffer for descriptor information. This firmware
+			  comes in 16, 32, and 48 channel builds. Each of these
+			  channels can be configured to monitor 32 contiguous
+			  queues.  Accumulator channel property is specified as:
+			  <pdsp-id, channel, entries, pacing mode, latency>
+			  pdsp-id     : QMSS PDSP running accumulator firmware
+					on which the channel has to be
+					configured
+			  channel     : Accumulator channel number
+			  entries     : Size of the accumulator descriptor list
+			  pacing mode : Interrupt pacing mode
+					0 : None, i.e interrupt on list full only
+					1 : Time delay since last interrupt
+					2 : Time delay since first new packet
+					3 : Time delay since last new packet
+			  latency     : time to delay the interrupt, specified
+					in microseconds.
+  -- multi-queue	: Optional property to specify that the channel has to
+			  monitor upto 32 queues starting at the base queue #.
+- descriptor-regions	: child node describing the memory regions for keystone
+			  navigator packet DMA descriptors. The memory for
+			  descriptors will be allocated by the driver.
+  -- id				: region number in QMSS.
+  -- region-spec		: specifies the number of descriptors in the
+				  region, specified as
+				  <"# of descriptors" "descriptor size">.
+  -- link-index			: start index, i.e. index of the first
+				  descriptor in the region.
+
+Optional properties:
+- dma-coherent	: Present if DMA operations are coherent.
+- pdsps		: child node describing the PDSP configuration.
+  -- firmware		: firmware to be loaded on the PDSP.
+  -- id			: the qmss pdsp that will run the firmware.
+  -- reg		: Address and size of the register set for the PDSP.
+			  Register regions should be specified in the following
+			  order
+			  - PDSP internal RAM region.
+			  - PDSP control/status region registers.
+			  - QMSS interrupt distributor registers.
+			  - PDSP command interface region.
+
+Example:
+
+qmss: qmss@2a40000 {
+	compatible = "ti,keystone-qmss";
+	dma-coherent;
+	#address-cells = <1>;
+	#size-cells = <1>;
+	clocks = <&chipclk13>;
+	ranges;
+	queue-range	= <0 0x4000>;
+	linkram0	= <0x100000 0x8000>;
+	linkram1	= <0x0 0x10000>;
+
+	qmgrs {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		qmgr0 {
+			managed-queues = <0 0x2000>;
+			reg = <0x2a40000 0x20000>,
+			      <0x2a06000 0x400>,
+			      <0x2a02000 0x1000>,
+			      <0x2a03000 0x1000>,
+			      <0x23a80000 0x20000>,
+			      <0x2a80000 0x20000>;
+		};
+
+		qmgr1 {
+			managed-queues = <0x2000 0x2000>;
+			reg = <0x2a60000 0x20000>,
+			      <0x2a06400 0x400>,
+			      <0x2a04000 0x1000>,
+			      <0x2a05000 0x1000>,
+			      <0x23aa0000 0x20000>,
+			      <0x2aa0000 0x20000>;
+		};
+	};
+	queue-pools {
+		qpend {
+			qpend-0 {
+				qrange = <658 8>;
+				interrupts =<0 40 0xf04 0 41 0xf04 0 42 0xf04
+					     0 43 0xf04 0 44 0xf04 0 45 0xf04
+					     0 46 0xf04 0 47 0xf04>;
+			};
+			qpend-1 {
+				qrange = <8704 16>;
+				interrupts = <0 48 0xf04 0 49 0xf04 0 50 0xf04
+					      0 51 0xf04 0 52 0xf04 0 53 0xf04
+					      0 54 0xf04 0 55 0xf04 0 56 0xf04
+					      0 57 0xf04 0 58 0xf04 0 59 0xf04
+					      0 60 0xf04 0 61 0xf04 0 62 0xf04
+					      0 63 0xf04>;
+				qalloc-by-id;
+			};
+			qpend-2 {
+				qrange = <8720 16>;
+				interrupts = <0 64 0xf04 0 65 0xf04 0 66 0xf04
+					      0 59 0xf04 0 68 0xf04 0 69 0xf04
+					      0 70 0xf04 0 71 0xf04 0 72 0xf04
+					      0 73 0xf04 0 74 0xf04 0 75 0xf04
+					      0 76 0xf04 0 77 0xf04 0 78 0xf04
+					      0 79 0xf04>;
+			};
+		};
+		general-purpose {
+			gp-0 {
+				qrange = <4000 64>;
+			};
+			netcp-tx {
+				qrange = <640 9>;
+				qalloc-by-id;
+			};
+		};
+		accumulator {
+			acc-0 {
+				qrange = <128 32>;
+				accumulator = <0 36 16 2 50>;
+				interrupts = <0 215 0xf01>;
+				multi-queue;
+				qalloc-by-id;
+			};
+			acc-1 {
+				qrange = <160 32>;
+				accumulator = <0 37 16 2 50>;
+				interrupts = <0 216 0xf01>;
+				multi-queue;
+			};
+			acc-2 {
+				qrange = <192 32>;
+				accumulator = <0 38 16 2 50>;
+				interrupts = <0 217 0xf01>;
+				multi-queue;
+			};
+			acc-3 {
+				qrange = <224 32>;
+				accumulator = <0 39 16 2 50>;
+				interrupts = <0 218 0xf01>;
+				multi-queue;
+			};
+		};
+	};
+	descriptor-regions {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		region-12 {
+			id = <12>;
+			region-spec = <8192 128>; /* num_desc desc_size */
+			link-index = <0x4000>;
+		};
+	};
+	pdsps {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		pdsp0@0x2a10000 {
+			firmware = "keystone/qmss_pdsp_acc48_k2_le_1_0_0_8.fw";
+			reg = <0x2a10000 0x1000>,
+			      <0x2a0f000 0x100>,
+			      <0x2a0c000 0x3c8>,
+			      <0x2a20000 0x4000>;
+			id = <0>;
+		};
+	};
+}; /* qmss */
-- 
1.7.9.5

