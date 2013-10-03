Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3JCXHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:07:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:35718 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab3JCXHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:07:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1028,1371106800"; 
   d="scan'208";a="413747604"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <greg@kroah.com>
CC: Peng Tao <tao.peng@emc.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lustre: why does cfs_get_random_bytes() exist?
Thread-Topic: lustre: why does cfs_get_random_bytes() exist?
Thread-Index: AQHOwFckUwawBx6iCEW+T1+NaTzynpnjsASAgAAj3QD//9a5AA==
Date: Thu, 3 Oct 2013 23:06:58 +0000
Message-ID: <CE732F62.74A88%andreas.dilger@intel.com>
In-Reply-To: <20131003193442.GB8000@thunk.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.125.217]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CDA4D0B22BB5834285231C400BD75518@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/03 1:34 PM, "Theodore Ts'o" <tytso@mit.edu> wrote:
>On Thu, Oct 03, 2013 at 10:26:21AM -0700, Greg KH wrote:
>> > Does this sound reasonable?
>> 
>> Sounds reasonable to me, care to send a patch to do so?
>> 
>
>I can do that, but I was waiting for Andras, Peng or Nikita to let me
>now if there was something I was missing or not.  I'm pretty sure it's
>something bogus, perhaps left over from a OS abstraction layer to
>support Solaris or some such, but I am curious what was the historical
>reason for the current code.

The root of the problem with the existing get_random_bytes() is that when
the
Cray supercomputers with around 20k nodes reboot all at the same instant,
we
had problems with the Lustre client UUID (originally from
generate_random_uuid())
being identical between multiple nodes since they have virtually no
entropy at
boot time, and they and did not have hardware RNG.

The Lustre cfs_get_random_bytes() incorporates (via cfs_rand()) a seed
which
also hashes in the addresses from any network interfaces that are
configured.
Conversely, cfs_rand() also is seeded at startup from get_random_bytes() in
case a hardware RNG is available.  This ensures even with identical initial
conditions cfs_get_random_bytes() gets a different random stream on each
node.

It is also true that cfs_get_random_bytes() and cfs_rand() predate the
newer
APIs such as prandom_u32() (which, to be honest, I didn't even know existed
today).  This is work that was done for maybe 2.4.29? (RH 9?) kernels.

The number of users of cfs_get_random_bytes() is relatively small, mostly
just
for the client UUID and other unique identifiers at startup time.  The only
place it is used on an ongoing basis is for the capabilities that are
passed
from the metadata server to clients so the clients can validate they have
access
to the objects on the data server.  The rest of the code uses cfs_rand()
for
values that only need to be statistically uniform over time, so they don't
deplete the entropy pool.

I'm not against cleaning this up, if there is some mechanism for the
startup
code to add in the node interface addresses into the entropy pool, and this
is also used to perturb the prandom_u32() sequence after that point.
Besides
that initialization, it would be a simple search & replace for the users.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


