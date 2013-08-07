Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab3HGHpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:45:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:1093 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab3HGHpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:45:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,831,1367996400"; 
   d="scan'208";a="383106546"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Xiong Zhou <jencce.kernel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Paul Bolle <pebolle@tiscali.nl>,
        Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH v2] staging/lustre: lloop depends on BLOCK
Thread-Topic: [PATCH v2] staging/lustre: lloop depends on BLOCK
Thread-Index: AQHOjLwGfTLDngp0wkGXFdutzRRQL5mAgt+AgABXF4CAAV3YAIAHQ5oA
Date: Wed, 7 Aug 2013 07:45:17 +0000
Message-ID: <CE26E579.5A0ED%andreas.dilger@intel.com>
In-Reply-To: <20130802104930.GB1718@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.108.15]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89BC7638C376A1439CB53BF5E919E81D@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/08/02 4:49 AM, "Christoph Hellwig" <hch@infradead.org> wrote:
>On Thu, Aug 01, 2013 at 07:57:22PM +0000, Dilger, Andreas wrote:
>> It provides significant performance improvement for network IO on
>>Lustre.
>> It bypasses DLM locking in Lustre and the VFS layer on the client,
>>copying
>> in the loop driver, and page-by-page IO submission in the normal IO
>>path.
>
>Part of being upstream is improving existing drivers instead of copy and
>pasting them.  Please take a Look at Shaggys in-kernel direct I/O and
>loop improvements and submit any incremental improvements ontop of that
>one.

The problem still remains that the kernel loop driver eventually depends on
a local block device for the pages/bios to be written.  The Lustre lloop
driver bypasses the VFS and block layer to generate RPCs from the submitted
pages to RDMA over the network without a data copy.

I wouldn't think that anyone would want a Lustre-specific RPC engine in the
standard loop.c file, nor would it be practical due to symbol dependencies.

I could imagine being able to register do_bio_lustrebacked() as a BIO
submission
routine instead of do_bio_filebacked(), along with some private data to
link
the loop file to the underlying storage (in Lustre's case an object layout
and
a preallocated I for generating the RPC).

How to register this from userspace compared to a normal file-backed loop
might be a bit tricky.  Lustre uses its own ioctls to register/deregister
the
device, though I could imagine some kind of per-file(system) method table
for
specifying the underlying bio submission routine.

In any case, rewriting the lloop/loop driver to merge this functionality
is not
high on the priority list compared to other Lustre code that needs to be
cleaned
up before it can be merged into the main kernel tree.  Can we leave this
code
as-is for now, and decide whether to rewrite or remove it when we are
closer to
having the rest of the code cleaned up?

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


