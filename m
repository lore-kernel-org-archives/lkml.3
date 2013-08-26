Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3HZVHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:07:10 -0400
Received: from a9-54.smtp-out.amazonses.com ([54.240.9.54]:46741 "EHLO
	a9-54.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650Ab3HZVHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:07:08 -0400
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 17:07:07 EDT
Message-ID: <00000140bc69ace7-f1bfaae1-ce5a-4c09-9635-340e29d3c6c8-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 26 Aug 2013 20:56:17 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv v2 29/31] parisc: Replace __get_cpu_var uses
References: <20130826204351.725357339@linux.com>
X-SES-Outgoing: 2013.08.26-54.240.9.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_cpu_var() is used for multiple purposes in the kernel source. One of them is
address calculation via the form &__get_cpu_var(x). This calculates the address for
the instance of the percpu variable of the current processor based on an offset.

Others usage cases are for storing and retrieving data from the current processors percpu area.
__get_cpu_var() can be used as an lvalue when writing data or on the right side of an assignment.

__get_cpu_var() is defined as :


#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))



__get_cpu_var() always only does a address determination. However, store and retrieve operations
could use a segment prefix (or global register on other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into a percpu area and use
optimized assembly code to read and write per cpu variables.


This patch converts __get_cpu_var into either and explicit address calculation using this_cpu_ptr()
or into a use of this_cpu operations that use the offset. Thereby address calcualtions are avoided
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

	memcpy(this_cpu_ptr(&y), x, sizeof(x));


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



Index: linux/arch/parisc/lib/memcpy.c
===================================================================
--- linux.orig/arch/parisc/lib/memcpy.c	2013-08-26 13:28:53.000000000 -0500
+++ linux/arch/parisc/lib/memcpy.c	2013-08-26 13:30:41.656224744 -0500
@@ -470,7 +470,7 @@ static unsigned long pa_memcpy(void *dst
 		return 0;
 
 	/* if a load or store fault occured we can get the faulty addr */
-	d = &__get_cpu_var(exception_data);
+	d = this_cpu_ptr(&exception_data);
 	fault_addr = d->fault_addr;
 
 	/* error in load or store? */
Index: linux/arch/parisc/mm/fault.c
===================================================================
--- linux.orig/arch/parisc/mm/fault.c	2013-08-26 13:28:53.000000000 -0500
+++ linux/arch/parisc/mm/fault.c	2013-08-26 13:30:41.656224744 -0500
@@ -145,7 +145,7 @@ int fixup_exception(struct pt_regs *regs
 	fix = search_exception_tables(regs->iaoq[0]);
 	if (fix) {
 		struct exception_data *d;
-		d = &__get_cpu_var(exception_data);
+		d = this_cpu_ptr(&exception_data);
 		d->fault_ip = regs->iaoq[0];
 		d->fault_space = regs->isr;
 		d->fault_addr = regs->ior;

