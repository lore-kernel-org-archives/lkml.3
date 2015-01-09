Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbbAIX53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:57:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:53564 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbbAIX52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:57:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="510156528"
Subject: Re: [PATCH char-misc-next 01/13] misc: mic: SCIF header file and
 IOCTL interface
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sudeep.dutt@intel.com, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
In-Reply-To: <20150109230436.GA3614@kroah.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
	 <f1e39531f80caf7ce014b31400064ec98863e182.1418237176.git.sudeep.dutt@intel.com>
	 <20150109230436.GA3614@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jan 2015 15:57:14 -0800
Message-ID: <1420847834.6393.2.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 15:04 -0800, Greg Kroah-Hartman wrote:
> On Wed, Dec 10, 2014 at 11:47:41AM -0800, Sudeep Dutt wrote:
> > This patch introduces the SCIF documentation in the header file
> > and describes the IOCTL interface for user mode. mic_overview.txt
> > is updated with documentation on SCIF and a new document
> > describing SCIF in more details is available in scif_overview.txt.
> > 
> > Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
> > Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> > Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
> > ---
> >  Documentation/mic/mic_overview.txt  |   28 +-
> >  Documentation/mic/scif_overview.txt |   62 ++
> >  include/uapi/linux/Kbuild           |    1 +
> >  include/linux/scif.h                | 1132 +++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/scif_ioctl.h     |  233 +++++++
> >  5 files changed, 1444 insertions(+), 12 deletions(-)
> >  create mode 100644 Documentation/mic/scif_overview.txt
> >  create mode 100644 include/linux/scif.h
> >  create mode 100644 include/uapi/linux/scif_ioctl.h
> > 
> > diff --git a/Documentation/mic/mic_overview.txt b/Documentation/mic/mic_overview.txt
> > index 77c5418..1a2f2c8 100644
> > --- a/Documentation/mic/mic_overview.txt
> > +++ b/Documentation/mic/mic_overview.txt
> > @@ -24,6 +24,10 @@ a virtual bus called mic bus is created and virtual dma devices are
> >  created on it by the host/card drivers. On host the channels are private
> >  and used only by the host driver to transfer data for the virtio devices.
> >  
> > +The Symmetric Communication Interface (SCIF (pronounced as skiff)) is a
> > +low level communications API across PCIe currently implemented for MIC.
> > +More details are available at scif_overview.txt.
> > +
> >  Here is a block diagram of the various components described above. The
> >  virtio backends are situated on the host rather than the card given better
> >  single threaded performance for the host compared to MIC, the ability of
> > @@ -47,18 +51,18 @@ the fact that the virtio block storage backend can only be on the host.
> >                        |               |       | Virtio over PCIe IOCTLs  |
> >                        |               |       +--------------------------+
> >  +-----------+         |               |                   |  +-----------+
> > -| MIC DMA   |         |               |                   |  | MIC DMA   |
> > -| Driver    |         |               |                   |  | Driver    |
> > -+-----------+         |               |                   |  +-----------+
> > -      |               |               |                   |        |
> > -+---------------+     |               |                   |  +----------------+
> > -|MIC virtual Bus|     |               |                   |  |MIC virtual Bus |
> > -+---------------+     |               |                   |  +----------------+
> > -      |               |               |                   |              |
> > -      |   +--------------+            |            +---------------+     |
> > -      |   |Intel MIC     |            |            |Intel MIC      |     |
> > -      +---|Card Driver   |            |            |Host Driver    |     |
> > -          +--------------+            |            +---------------+-----+
> > +| MIC DMA   |         |  +----------+ | +-----------+     |  | MIC DMA   |
> > +| Driver    |         |  |  SCIF    | | |   SCIF    |     |  | Driver    |
> > ++-----------+         |  +----------+ | +-----------+     |  +-----------+
> > +      |               |       |       |       |           |        |
> > ++---------------+     | +-----+-----+ | +-----+-----+     | +---------------+
> > +|MIC virtual Bus|     | |SCIF HW Bus| | |SCIF HW BUS|     | |MIC virtual Bus|
> > ++---------------+     | +-----------+ | +-----+-----+     | +---------------+
> > +      |               |       |       |       |           |              |
> > +      |   +--------------+    |       |       |    +---------------+     |
> > +      |   |Intel MIC     |    |       |       |    |Intel MIC      |     |
> > +      +---|Card Driver   +----+       |       |    |Host Driver    |     |
> > +          +--------------+            |       +----+---------------+-----+
> >                        |               |                   |
> >               +-------------------------------------------------------------+
> >               |                                                             |
> > diff --git a/Documentation/mic/scif_overview.txt b/Documentation/mic/scif_overview.txt
> > new file mode 100644
> > index 0000000..75549c4
> > --- /dev/null
> > +++ b/Documentation/mic/scif_overview.txt
> > @@ -0,0 +1,62 @@
> > +The Symmetric Communication Interface (SCIF (pronounced as skiff)) is a low
> > +level communications API across PCIe currently implemented for MIC. Currently
> > +SCIF provides inter-node communication within a single host platform, where a
> > +node is a MIC Coprocessor or Xeon based host. SCIF abstracts the details of
> > +communicating over the PCIe bus while providing an API that is symmetric
> > +across all the nodes in the PCIe network. An important design objective for SCIF
> > +is to deliver the maximum possible performance given the communication
> > +abilities of the hardware. SCIF has been used to implement an offload compiler
> > +runtime and OFED support for MPI implementations for MIC coprocessors.
> > +
> > +==== SCIF API Components ====
> > +The SCIF API has the following parts:
> > +1. Connection establishment using a client server model
> > +2. Byte stream messaging intended for short messages
> > +3. Node enumeration to determine online nodes
> > +4. Poll semantics for detection of incoming connections and messages
> > +5. Memory registration to pin down pages
> > +6. Remote memory mapping for low latency CPU accesses via mmap
> > +7. Remote DMA (RDMA) for high bandwidth DMA transfers
> > +8. Fence APIs for RDMA synchronization
> > +
> > +SCIF exposes the notion of a connection which can be used by peer processes on
> > +nodes in a SCIF PCIe "network" to share memory "windows" and to communicate. A
> > +process in a SCIF node initiates a SCIF connection to a peer process on a
> > +different node via a SCIF "endpoint". SCIF endpoints support messaging APIs
> > +which are similar to connection oriented socket APIs. Connected SCIF endpoints
> > +can also register local memory which is followed by data transfer using either
> > +DMA, CPU copies or remote memory mapping via mmap. SCIF supports both user and
> > +kernel mode clients which are functionally equivalent.
> > +
> > +==== SCIF Performance for MIC ====
> > +DMA bandwidth comparison between the TCP (over ethernet over PCIe) stack versus
> > +SCIF shows the performance advantages of SCIF for HPC applications and runtimes.
> > +
> > +             Comparison of TCP and SCIF based BW
> > +
> > +  Throughput (GB/sec)
> > +    8 +                                             PCIe Bandwidth ******
> > +      +                                                        TCP ######
> > +    7 +    **************************************             SCIF %%%%%%
> > +      |                       %%%%%%%%%%%%%%%%%%%
> > +    6 +                   %%%%
> > +      |                 %%
> > +      |               %%%
> > +    5 +              %%
> > +      |            %%
> > +    4 +           %%
> > +      |          %%
> > +    3 +         %%
> > +      |        %
> > +    2 +      %%
> > +      |     %%
> > +      |    %
> > +    1 +
> > +      +    ######################################
> > +    0 +++---+++--+--+-+--+--+-++-+--+-++-+--+-++-+-
> > +      1       10     100      1000   10000   100000
> > +                   Transfer Size (KBytes)
> > +
> > +SCIF allows memory sharing via mmap(..) between processes on different PCIe
> > +nodes and thus provides bare-metal PCIe latency. The round trip SCIF mmap
> > +latency from the host to an x100 MIC for an 8 byte message is 0.44 usecs.
> > diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> > index 4c94f31..9083b60 100644
> > --- a/include/uapi/linux/Kbuild
> > +++ b/include/uapi/linux/Kbuild
> > @@ -345,6 +345,7 @@ header-y += rtc.h
> >  header-y += rtnetlink.h
> >  header-y += scc.h
> >  header-y += sched.h
> > +header-y += scif_ioctl.h
> >  header-y += screen_info.h
> >  header-y += sctp.h
> >  header-y += sdla.h
> > diff --git a/include/linux/scif.h b/include/linux/scif.h
> > new file mode 100644
> > index 0000000..a0652a6
> > --- /dev/null
> > +++ b/include/linux/scif.h
> > @@ -0,0 +1,1132 @@
> > +/*
> > + * Intel MIC Platform Software Stack (MPSS)
> > + *
> > + * This file is provided under a dual BSD/GPLv2 license.  When using or
> > + * redistributing this file, you may do so under either license.
> > + *
> > + * GPL LICENSE SUMMARY
> > + *
> > + * Copyright(c) 2014 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of version 2 of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + *
> > + * BSD LICENSE
> > + *
> > + * Copyright(c) 2014 Intel Corporation.
> > + *
> > + * Redistribution and use in source and binary forms, with or without
> > + * modification, are permitted provided that the following conditions
> > + * are met:
> > + *
> > + * * Redistributions of source code must retain the above copyright
> > + *   notice, this list of conditions and the following disclaimer.
> > + * * Redistributions in binary form must reproduce the above copyright
> > + *   notice, this list of conditions and the following disclaimer in
> > + *   the documentation and/or other materials provided with the
> > + *   distribution.
> > + * * Neither the name of Intel Corporation nor the names of its
> > + *   contributors may be used to endorse or promote products derived
> > + *   from this software without specific prior written permission.
> > + *
> > + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> > + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> > + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> > + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> > + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> > + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> > + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> > + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> > + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> > + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> > + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> > + *
> > + * Intel SCIF driver.
> > + *
> > + */
> > +#ifndef __SCIF_H__
> > +#define __SCIF_H__
> > +
> > +#include <linux/types.h>
> > +#include <linux/poll.h>
> > +#include <linux/scif_ioctl.h>
> > +
> > +#define SCIF_ACCEPT_SYNC	1
> > +#define SCIF_SEND_BLOCK		1
> > +#define SCIF_RECV_BLOCK		1
> > +
> > +enum {
> > +	SCIF_PROT_READ = (1 << 0),
> > +	SCIF_PROT_WRITE = (1 << 1)
> > +};
> > +
> > +enum {
> > +	SCIF_MAP_FIXED = 0x10,
> > +	SCIF_MAP_KERNEL	= 0x20,
> > +};
> > +
> > +enum {
> > +	SCIF_FENCE_INIT_SELF = (1 << 0),
> > +	SCIF_FENCE_INIT_PEER = (1 << 1),
> > +	SCIF_SIGNAL_LOCAL = (1 << 4),
> > +	SCIF_SIGNAL_REMOTE = (1 << 5)
> > +};
> > +
> > +enum {
> > +	SCIF_RMA_USECPU = (1 << 0),
> > +	SCIF_RMA_USECACHE = (1 << 1),
> > +	SCIF_RMA_SYNC = (1 << 2),
> > +	SCIF_RMA_ORDERED = (1 << 3)
> > +};
> > +
> > +/* End of SCIF Admin Reserved Ports */
> > +#define SCIF_ADMIN_PORT_END	1024
> > +
> > +/* End of SCIF Reserved Ports */
> > +#define SCIF_PORT_RSVD		1088
> > +
> > +typedef struct scif_endpt *scif_epd_t;
> > +
> > +#define SCIF_OPEN_FAILED ((scif_epd_t)-1)
> > +#define SCIF_REGISTER_FAILED ((off_t)-1)
> > +#define SCIF_MMAP_FAILED ((void *)-1)
> > +
> > +/**
> > + * scif_open - Create an endpoint
> > + *
> > + *\return
> > + * Upon successful completion, scif_open() returns an endpoint descriptor to
> > + * be used in subsequent SCIF functions calls to refer to that endpoint;
> > + * otherwise: in user mode SCIF_OPEN_FAILED (that is ((scif_epd_t)-1)) is
> > + * returned and errno is set to indicate the error; in kernel mode a NULL
> > + * scif_epd_t is returned.
> > + *
> > + *\par Errors:
> > + *- ENOMEM
> > + * - Insufficient kernel memory was available
> > + */
> 
> Documentation is great, but if you are going to do it, use the proper
> kerneldoc format and not some other odd variant that I have never seen
> before.  This whole patch has tons of oddly labled comments, like this:
> 

This file was set up for being an input into doxygen some time back. I
agree that it looks really odd so will fix it up and send across a v2
early next week.

Thanks,
Sudeep Dutt

