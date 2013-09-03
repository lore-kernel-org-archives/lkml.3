Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab3ICTGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:06:12 -0400
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:58330 "EHLO
	a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933528Ab3ICTFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:05:23 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Sep 2013 15:05:23 EDT
Message-ID: <00000140e5326413-56d19a1a-4235-403e-b210-bbd387913a83-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Tue, 3 Sep 2013 19:00:20 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [gcv v4 00/38] percpu v4: [RFC] Replace __get_cpu_var
X-SES-Outgoing: 2013.09.03-54.240.9.99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3->v4:
- Back to RFC status. The preemption checks will certainly cause some trouble and
  the way that raw ops and preemption checks were introduced needs review.
- Various fixes.

V2->V3:
- Numerous corrections
- Patch flow will be through individual maintainers tree. Rest will be merged
  via percpu tree.
- Break up the drivers patch into patches for individual maintainer domains
- The patches are available via git from git://gentwo.org/christoph gcv
- Drop tile arch portion since that one is going to be merged by Chris Metcalf.

V1->V2:
 - Break up larger patches.
 - CC maintainers
 - Include description in each patch.

__get_cpu_var() is used for multiple purposes in the kernel source. One of them is
address calculation via the form &__get_cpu_var(x). This calculates the address for
the instance of the percpu variable of the current processor based on an offset.

Other use cases are for storing and retrieving data from the current processors percpu area.
__get_cpu_var() can be used as an lvalue when writing data or on the right side of an assignment.

__get_cpu_var() is defined as :


#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))



__get_cpu_var() always only does an address determination. However, store and retrieve operations
could use a segment prefix (or global register on other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into a percpu area and use
optimized assembly code to read and write per cpu variables.


This patch converts __get_cpu_var into either an explicit address calculation using this_cpu_ptr()
or into a use of this_cpu operations that use the offset. Thereby address calculations are avoided
and less registers are used when code is generated.

At the end of the patchset all uses of __get_cpu_var have been removed so the macro is removed too.

The patchset includes passes over all arches as well. Once these operations are used throughout then
specialized macros can be defined in non -x86 arches as well in order to optimize per cpu access by
f.e. using a global register that may be set to the per cpu base.




Transformations done to __get_cpu_var()


1. Determine the address of the percpu instance of the current processor.

	DEFINE_PER_CPU(int, y);
	int *x = &__get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(&y);


2. Same as #1 but this time an array structure is involved.

	DEFINE_PER_CPU(int, y[20]);
	int *x = __get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(y);


3. Retrieve the content of the current processors instance of a per cpu variable.

	DEFINE_PER_CPU(int, u);
	int x = __get_cpu_var(y)

   Converts to

	int x = __this_cpu_read(y);


4. Retrieve the content of a percpu struct

	DEFINE_PER_CPU(struct mystruct, y);
	struct mystruct x = __get_cpu_var(y);

   Converts to

	memcpy(this_cpu_ptr(&x), y, sizeof(x));


5. Assignment to a per cpu variable

	DEFINE_PER_CPU(int, y)
	__get_cpu_var(y) = x;

   Converts to

	this_cpu_write(y, x);


6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	this_cpu_inc(y)


These conversions lead to some savings in code size.

Before

size arch/x86/boot/bzImage
   text	   data	    bss	    dec	    hex	filename
3996624	      0	      0	3996624	 3cfbd0	arch/x86/boot/bzImage

After

size arch/x86/boot/bzImage
   text	   data	    bss	    dec	    hex	filename
3995840	      0	      0	3995840	 3cf8c0	arch/x86/boot/bzImage


