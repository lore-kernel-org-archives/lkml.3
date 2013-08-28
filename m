Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3H1Uvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:51:55 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:57105 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755040Ab3H1Uvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:51:54 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 16:51:53 EDT
Date: Wed, 28 Aug 2013 20:42:19 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
In-Reply-To: <20130828195415.GP6617@n2100.arm.linux.org.uk>
Message-ID: <00000140c6a99df3-87c7c3c3-944c-4559-a8de-b7b220f1bc37-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com> <20130828195415.GP6617@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013, Russell King - ARM Linux wrote:

> On Wed, Aug 28, 2013 at 07:48:23PM +0000, Christoph Lameter wrote:
> > 3. Retrieve the content of the current processors instance of a per cpu variable.
> >
> > 	DEFINE_PER_CPU(int, u);
>
> Shouldn't this be 'y' ?

Right.

> > 	memcpy(this_cpu_ptr(&x), y, sizeof(x));
>
> Are you sure this one's correct?  Isn't 'y' the per-cpu variable?

Also true. Already fixed this once. Sigh.

Description patch:


--- this_x86	2013-08-28 15:35:48.933416126 -0500
+++ patches/this_x86	2013-08-28 15:41:14.386260894 -0500
@@ -26,12 +26,12 @@


 This patch converts __get_cpu_var into either an explicit address calculation using this_cpu_ptr()
-or into a use of this_cpu operations that use the offset. Thereby address calcualtions are avoided
+or into a use of this_cpu operations that use the offset. Thereby address calculations are avoided
 and less registers are used when code is generated.

-At the end of the patchset all uses of __get_cpu_var have been removed so the macro is removed too.
+At the end of the patch set all uses of __get_cpu_var have been removed so the macro is removed too.

-The patchset includes passes over all arches as well. Once these operations are used throughout then
+The patch set includes passes over all arches as well. Once these operations are used throughout then
 specialized macros can be defined in non -x86 arches as well in order to optimize per cpu access by
 f.e. using a global register that may be set to the per cpu base.

@@ -63,7 +63,7 @@

 3. Retrieve the content of the current processors instance of a per cpu variable.

-	DEFINE_PER_CPU(int, u);
+	DEFINE_PER_CPU(int, y);
 	int x = __get_cpu_var(y)

    Converts to
@@ -78,7 +78,7 @@

    Converts to

-	memcpy(this_cpu_ptr(&x), y, sizeof(x));
+	memcpy(&x, this_cpu_ptr(&y), sizeof(x));


 5. Assignment to a per cpu variable
