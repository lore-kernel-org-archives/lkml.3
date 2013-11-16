Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3KPKgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 05:36:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:4214 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab3KPKgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 05:36:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,712,1378882800"; 
   d="scan'208";a="428734605"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/40] staging/lustre/llite: Access to released file
 trigs a restore
Thread-Topic: [PATCH 04/40] staging/lustre/llite: Access to released file
 trigs a restore
Thread-Index: AQHO4VSkbkzjm/KXjUGaI1FFrak8DpomNHoAgAF4NwA=
Date: Sat, 16 Nov 2013 10:36:18 +0000
Message-ID: <CEAC7771.817BF%andreas.dilger@intel.com>
In-Reply-To: <20131115040944.GA28070@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.124.174]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <044EB681E8C03C439A6A3078172AAC13@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/14 9:09 PM, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
wrote:
>On Fri, Nov 15, 2013 at 12:13:06AM +0800, Peng Tao wrote:
>> From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
>> 
>> When a client accesses data in a released file,
>> or truncate it, client must trig a restore request.
>> During this restore, the client must not glimpse and
>> must use size from MDT. To bring the "restore is running"
>> information on the client we add a new t_state bit field
>> to mdt_info which will be used to carry transient file state.
>> To memorise this information in the inode we add a new flag
>> LLIF_FILE_RESTORING.
>
>This patch also does other things not mentioned here (coding style
>cleanups), which isn't allowed in a single patch (only do one thing per
>patch, and never not document what you are doing...)
>
>It also adds checkpatch warnings, which I will not accept in patches at
>all here.  People are spending a lot of time cleaning up the coding
>style issues, please NEVER add new ones, that just causes more work to
>be needed to be done, and for people to have to go back and reclean
>files they have already cleaned up.

I'm fine to clean up the coding style issues in these patches.

>So, sorry, I have to stop here at this series.  I've applied the first 3
>to the opw-next branch of staging.git so they can live somewhere until
>3.13-rc1 is out.
>
>I know you spent a lot of time making these 120 patches to send me, but
>that too is crazy.  You shouldn't wait that long to get feedback and
>send patches to me at all.  Please send them in smaller series, with
>less time between patch submissions.

The reason that there are so many patches in a burst is that we are also
developing new features and fixing bugs in parallel with the kernel, but
they also need to be tested a lot before they are released.  It's not any
different from kernel patches testing on -next or -mm for a few months
before they are pushed to the mainline kernel in a batch.

The out-of-tree development can't really stop for a year while the kernel
client code is cleaned up.  If the feature patches don't land into the
kernel client for a year (or however long it takes to do all the cleanup),
then it will become outdated and the whole reason for adding the client
into the kernel is lost.

>> There are many users of the external tree so we cannot just abandon
>> it, especially that the upstream client is not shipped in any
>> distribution yet. Thanks for your understanding.
>
>What is keeping people using that tree?  Support for older/distro
>kernels?
>

Support for distro kernels is a big part of it.  Most HPC sites use vendor
kernels of various vintages, and we need to keep the code working for those
sites.  We also need to continue developing features needed by ever-larger
clusters, fixing bugs, etc.  Eventually, when Lustre is in the kernel
proper,
it will also be available in future distro kernels and we can eventually
stop supporting the out-of-tree code.  I expect that to be 3+ years away.

>Is it the fact that the server code isn't in the kernel?

Not really.  Lustre servers are on separate servers with vendor kernels
(ancient by your standards), and there isn't really any demand for
using newer kernels on those nodes.  Most importantly, the out-of-tree
branch is where all of the new feature development is being done.  That
also means if feature patches don't land into the kernel it just makes
the kernel version less attractive for users.

>  Should that be added now too so that we can get a proper view of what
> can and can not be changed?  Some of your patches are showing that things
> are shared by the two chunks of code, so does that mean if I delete
>things in the client code that don't look to be used by anything, you
> will have problems because the server now breaks?

Adding the server code to staging would mean another 150kLOC in staging.
We also haven't cleaned that code up even nearly as much as the client
code, so it isn't really even ready to go into staging either.  I don't
think you or anyone else would be happy to see that code yet, so I don't
think there is a real advantage to do so.

Deleting unused code in the kernel client isn't fatal, since we'll
still have the out-of-tree version, but we're trying to keep the code in
sync as much as possible so that it is easier to port patches in both
directions.  If code is deleted it means more that needs to be added
back later when the server eventually does get merged, and more effort
to resolve patch conflicts.

>I think it's time to just merge the server and deal with the whole thing
>all at once, otherwise this dependancy on your external tree, and
>external code to the kernel, is going to doom the ability to ever get
>this code cleaned up and merged properly.

Regardless of whether the Lustre server is added to the kernel or not,
we need to maintain support for the older kernels, so there will need
to be an external tree for years to come until Lustre is available in
vendor kernels.  I'm sure we can't merge in the kernel-version-portable
code into the kernel, so there isn't really any choice but to try and
keep both trees in sync.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


