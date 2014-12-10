Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbaLJTtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:49:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:57532 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbaLJTtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770529"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 00/13] misc: mic: SCIF driver
Date: Wed, 10 Dec 2014 11:47:40 -0800
Message-Id: <cover.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Symmetric Communication Interface (SCIF (pronounced as skiff)) is a low
level communications API across PCIe currently implemented for MIC. Currently
SCIF provides inter-node communication within a single host platform, where a
node is a MIC Coprocessor or Xeon based host. SCIF abstracts the details of
communicating over the PCIe bus while providing an API that is symmetric
across all the nodes in the PCIe network. An important design objective for SCIF
is to deliver the maximum possible performance given the communication
abilities of the hardware. SCIF has been used to implement an offload compiler
runtime and OFED support for MPI implementations for MIC coprocessors.

==== SCIF API Components ====
The SCIF API has the following parts:
1. Connection establishment using a client server model
2. Byte stream messaging intended for short messages
3. Node enumeration to determine online nodes
4. Poll semantics for detection of incoming connections and messages
5. Memory registration to pin down pages
6. Remote memory mapping for low latency CPU accesses via mmap
7. Remote DMA (RDMA) for high bandwidth DMA transfers
8. Fence APIs for RDMA synchronization

SCIF exposes the notion of a connection which can be used by peer processes on
nodes in a SCIF PCIe "network" to share memory "windows" and to communicate. A
process in a SCIF node initiates a SCIF connection to a peer process on a
different node via a SCIF "endpoint". SCIF endpoints support messaging APIs
which are similar to connection oriented socket APIs. Connected SCIF endpoints
can also register local memory which is followed by data transfer using either
DMA, CPU copies or remote memory mapping via mmap. SCIF supports both user and
kernel mode clients which are functionally equivalent.

==== SCIF Performance for MIC ====
DMA bandwidth comparison between the TCP (over ethernet over PCIe) stack versus
SCIF shows the performance advantages of SCIF for HPC applications and runtimes.

             Comparison of TCP and SCIF based BW

  Throughput (GB/sec)
    8 +                                             PCIe Bandwidth ******
      +                                                        TCP ######
    7 +    **************************************             SCIF %%%%%%
      |                       %%%%%%%%%%%%%%%%%%%
    6 +                   %%%%
      |                 %%
      |               %%%
    5 +              %%
      |            %%
    4 +           %%
      |          %%
    3 +         %%
      |        %
    2 +      %%
      |     %%
      |    %
    1 +
      +    ######################################
    0 +++---+++--+--+-+--+--+-++-+--+-++-+--+-++-+-
      1       10     100      1000   10000   100000
                   Transfer Size (KBytes)

SCIF allows memory sharing via mmap(..) between processes on different PCIe
nodes and thus provides bare-metal PCIe latency. The round trip SCIF mmap
latency from the host to an x100 MIC for an 8 byte message is 0.44 usecs.

For more information on SCIF please refer to the Linux Con 2013 slides titled
"Intel® MIC x100 Coprocessor Driver - on the Frontiers of Linux & HPC" at
http://events.linuxfoundation.org/sites/events/files/slides/LinuxConMicDriver.pdf
The talk can also be viewed at https://www.youtube.com/watch?v=dylbmmQs4W0

This initial patch series introduces the SCIF API and implements the SCIF
connection, messaging and node enumeration APIs. SCIF poll, mmap, RDMA and
fence APIs will be submitted in a future patch series once the initial base
patches are accepted upstream.

This patch series is divided into 13 patches as follows:
1) SCIF header file documenting the API along with the IOCTL interface

2) SCIF ring buffer is a single producer, single consumer byte stream ring
   buffer optimized for avoiding reads across the PCIe bus. The ring buffer is
   used to implement a receive queue for SCIF driver messaging between nodes and
   for byte stream messaging between SCIF endpoints. Each SCIF node has a
   receive queue for every other SCIF node, and each connected endpoint has a
   receive queue for messages from its peer. This pair of receive queues is
   referred to as a SCIF queue pair.

3) SCIF hardware bus which abstracts the low level hardware details so that the
   same SCIF driver can work without any changes on the host or the card as long
   as the hardware bus operations are implemented.

4) SCIF peer bus is used to register and unregister SCIF peer devices internally
   by the SCIF driver to signify the addition and removal of peer nodes
   respectively from the SCIF network. This simplifies remote node handling
   within SCIF and will also be used to support device probe/remove for SCIF
   client drivers (e.g. netdev over SCIF)

5) Common MIC header file changes to enable SCIF

6) SCIF module initialization, DMA/remote memory mapping APIs and debugfs hooks.

7) SCIF node queue pair setup sets up the kernel mode private node
   queue pairs between all the nodes to enable internal control
   message communication.

8) SCIF character device file operations and kernel APIs for opening and
   closing a user and kernel mode SCIF endpoint. This patch also enables
   binding to a SCIF port and listening for incoming SCIF connections.

9) SCIF connection APIs which establish a SCIF connection between
   a pair of user or kernel mode endpoints.

10) SCIF messaging APIs which allow sending messages between the SCIF endpoints
    via a byte stream based ring buffer which has been optimized to avoid reads
    across PCIe. The node enumeration API enables a user to query for the number
    of online nodes.

11) MIC host driver specific changes to enable SCIF

12) MIC card driver specific changes to enable SCIF

13) Add support for loading/unloading SCIF driver

Nikhil Rao (1):
  misc: mic: SCIF connections APIs i.e. accept and connect

Sudeep Dutt (12):
  misc: mic: SCIF header file and IOCTL interface
  misc: mic: SCIF ring buffer infrastructure
  misc: mic: SCIF Hardware Bus
  misc: mic: SCIF Peer Bus
  misc: mic: Common MIC header file changes in preparation for SCIF
  misc: mic: SCIF module initialization
  misc: mic: SCIF node queue pair setup management
  misc: mic: SCIF open close bind and listen APIs
  misc: mic: SCIF messaging and node enumeration APIs
  misc: mic: MIC host driver specific changes to enable SCIF
  misc: mic: MIC card driver specific changes to enable SCIF
  misc: mic: add support for loading/unloading SCIF driver

 Documentation/mic/mic_overview.txt    |   28 +-
 Documentation/mic/scif_overview.txt   |   62 ++
 drivers/misc/mic/Kconfig              |   40 +-
 drivers/misc/mic/Makefile             |    3 +-
 drivers/misc/mic/bus/Makefile         |    1 +
 drivers/misc/mic/scif/Makefile        |   15 +
 include/uapi/linux/Kbuild             |    1 +
 drivers/misc/mic/bus/scif_bus.h       |  129 ++++
 drivers/misc/mic/card/mic_device.h    |   11 +-
 drivers/misc/mic/card/mic_x100.h      |    1 +
 drivers/misc/mic/common/mic_dev.h     |    3 +
 drivers/misc/mic/host/mic_device.h    |   11 +-
 drivers/misc/mic/host/mic_intr.h      |    3 +-
 drivers/misc/mic/host/mic_smpt.h      |    1 +
 drivers/misc/mic/scif/scif_epd.h      |  160 ++++
 drivers/misc/mic/scif/scif_main.h     |  250 +++++++
 drivers/misc/mic/scif/scif_map.h      |  113 +++
 drivers/misc/mic/scif/scif_nodeqp.h   |  182 +++++
 drivers/misc/mic/scif/scif_peer_bus.h |   63 ++
 drivers/misc/mic/scif/scif_rb.h       |  100 +++
 include/linux/scif.h                  | 1132 ++++++++++++++++++++++++++++
 include/uapi/linux/mic_common.h       |   12 +
 include/uapi/linux/scif_ioctl.h       |  233 ++++++
 drivers/misc/mic/bus/scif_bus.c       |  210 ++++++
 drivers/misc/mic/card/mic_device.c    |  132 +++-
 drivers/misc/mic/card/mic_x100.c      |   61 +-
 drivers/misc/mic/host/mic_boot.c      |  264 ++++++-
 drivers/misc/mic/host/mic_debugfs.c   |   13 +
 drivers/misc/mic/host/mic_main.c      |    6 +
 drivers/misc/mic/host/mic_smpt.c      |    7 +-
 drivers/misc/mic/host/mic_virtio.c    |    6 +-
 drivers/misc/mic/host/mic_x100.c      |    3 +-
 drivers/misc/mic/scif/scif_api.c      | 1270 ++++++++++++++++++++++++++++++++
 drivers/misc/mic/scif/scif_debugfs.c  |   82 +++
 drivers/misc/mic/scif/scif_epd.c      |  353 +++++++++
 drivers/misc/mic/scif/scif_fd.c       |  303 ++++++++
 drivers/misc/mic/scif/scif_main.c     |  395 ++++++++++
 drivers/misc/mic/scif/scif_nm.c       |  229 ++++++
 drivers/misc/mic/scif/scif_nodeqp.c   | 1303 +++++++++++++++++++++++++++++++++
 drivers/misc/mic/scif/scif_peer_bus.c |  124 ++++
 drivers/misc/mic/scif/scif_ports.c    |  124 ++++
 drivers/misc/mic/scif/scif_rb.c       |  248 +++++++
 Documentation/mic/mpssd/mpss          |   23 +-
 43 files changed, 7654 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/mic/scif_overview.txt
 create mode 100644 drivers/misc/mic/scif/Makefile
 create mode 100644 drivers/misc/mic/bus/scif_bus.h
 create mode 100644 drivers/misc/mic/scif/scif_epd.h
 create mode 100644 drivers/misc/mic/scif/scif_main.h
 create mode 100644 drivers/misc/mic/scif/scif_map.h
 create mode 100644 drivers/misc/mic/scif/scif_nodeqp.h
 create mode 100644 drivers/misc/mic/scif/scif_peer_bus.h
 create mode 100644 drivers/misc/mic/scif/scif_rb.h
 create mode 100644 include/linux/scif.h
 create mode 100644 include/uapi/linux/scif_ioctl.h
 create mode 100644 drivers/misc/mic/bus/scif_bus.c
 create mode 100644 drivers/misc/mic/scif/scif_api.c
 create mode 100644 drivers/misc/mic/scif/scif_debugfs.c
 create mode 100644 drivers/misc/mic/scif/scif_epd.c
 create mode 100644 drivers/misc/mic/scif/scif_fd.c
 create mode 100644 drivers/misc/mic/scif/scif_main.c
 create mode 100644 drivers/misc/mic/scif/scif_nm.c
 create mode 100644 drivers/misc/mic/scif/scif_nodeqp.c
 create mode 100644 drivers/misc/mic/scif/scif_peer_bus.c
 create mode 100644 drivers/misc/mic/scif/scif_ports.c
 create mode 100644 drivers/misc/mic/scif/scif_rb.c

-- 
1.8.2.1

