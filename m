Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab3CUHP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:15:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44836 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab3CUHP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:15:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130321070357.GD28328@redhat.com>
References: <20130321061838.GA28319@redhat.com> <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
 <20130321070357.GD28328@redhat.com>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 21 Mar 2013 00:15:33 -0700
X-Google-Sender-Auth: hvQ-DchnR9TnfPQdbG5J8CJKWkY
Message-ID: <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ@mail.gmail.com>
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I think this change will break the case where userspace tries to
>> register an MR with read-only permission, but intends locally through
>> the CPU to write to the memory.

> Shouldn't it set LOCAL_WRITE then?

We're talking about the permissions for the register MR operation,
right?  (That's what the kernel RDMA driver code that does
get_user_pages() sees)

In that case, no, I don't see any reason for LOCAL_WRITE, since the
only RDMA operations that will access this memory are remote reads.
The writing (that triggers COW) is coming from normal process access
triggering a page fault, etc.  This is a pretty standard way of using
RDMA... For example, I allocate some memory and register it for RDMA
read (and pass the R_Key to the remote system) with only REMOTE_READ
permission.  Then I fill in the memory with the results of some
computation and the remote system does an RDMA read to get those
results.

 - R.
