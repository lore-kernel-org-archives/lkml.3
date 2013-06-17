Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3FQKnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:43:11 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:53560 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3FQKnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:43:09 -0400
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Jan Beulich <JBeulich@suse.com>, Zach Bobroff <zacharyb@ami.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20130617101745.GB8569@console-pimps.org>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
	 <1371139233.6523.272.camel@linux-s257.site>
	 <20130617092107.GA5440@console-pimps.org>
	 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
	 <20130617101745.GB8569@console-pimps.org>
Content-Type: multipart/mixed; boundary="=-qKDLrrS1szolY5Edu2H+"
Date: Mon, 17 Jun 2013 18:41:30 +0800
Message-ID: <1371465690.6523.331.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qKDLrrS1szolY5Edu2H+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

於 一，2013-06-17 於 11:17 +0100，Matt Fleming 提到：
> On Mon, 17 Jun, at 10:46:28AM, Jan Beulich wrote:
> > To me, all this looks like it is being done on phenomenological basis,
> > taking a particular build of a particular firmware implementation as
> > the reference. Imo we shouldn't change the code in this way. This
> > also applies to the fact that the step is being doubled rather than
> > e.g. tripled: With it ending up a "again" anyway (see below), what's
> > the point of avoiding one more of the iterations?
> > 
> > Generic considerations would result in the increment being at least
> > 3 * element size; twice the element size assumes that the allocator
> > would behave in certain ways (like returning the head or tail part of
> > a larger piece of memory).
>  
> I have no issue with changing the multiplier. But let's get
> clarification from Zach as to what exactly is going on here.
> 
> > I agree that there ought to be an upper limit. But a single retry here
> > again looks like a tailored solution to a particular observed (mis-)
> > behavior, rather than something resulting from general considerations.
> 
> What value would you suggest for the retry?
> 

Currently grub2 retry unlimited times like attached patch.

But, I also agree need have a upper limit.


Thanks a lot!
Joey Lee


--=-qKDLrrS1szolY5Edu2H+
Content-Disposition: attachment; filename="bug-823386_grub-r4778.diff"
Content-Type: text/x-patch; name="bug-823386_grub-r4778.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

------------------------------------------------------------
revno: 4778
committer: Vladimir 'phcoder' Serbinenko <phcoder@gmail.com>
branch nick: grub
timestamp: Tue 2013-03-26 11:34:56 +0100
message:
  	* grub-core/kern/efi/mm.c (grub_efi_finish_boot_services):
  	Try terminating EFI services several times due to quirks in some
  	implementations.
diff:
=== modified file 'ChangeLog'
--- ChangeLog	2013-03-26 10:29:52 +0000
+++ ChangeLog	2013-03-26 10:34:56 +0000
@@ -1,3 +1,9 @@
+2013-03-26  Vladimir Serbinenko  <phcoder@gmail.com>
+
+	* grub-core/kern/efi/mm.c (grub_efi_finish_boot_services):
+	Try terminating EFI services several times due to quirks in some
+	implementations.
+
 2013-03-26  Colin Watson  <cjwatson@ubuntu.com>
 
 	* grub-core/commands/acpihalt.c (skip_ext_op): Add support for

=== modified file 'grub-core/kern/efi/mm.c'
--- grub-core/kern/efi/mm.c	2013-01-13 01:10:41 +0000
+++ grub-core/kern/efi/mm.c	2013-03-26 10:34:56 +0000
@@ -160,27 +160,41 @@
 			   apple, sizeof (apple)) == 0);
 #endif
 
-  if (grub_efi_get_memory_map (&finish_mmap_size, finish_mmap_buf, &finish_key,
-			       &finish_desc_size, &finish_desc_version) < 0)
-    return grub_error (GRUB_ERR_IO, "couldn't retrieve memory map");
-
-  if (outbuf && *outbuf_size < finish_mmap_size)
-    return grub_error (GRUB_ERR_IO, "memory map buffer is too small");
-
-  finish_mmap_buf = grub_malloc (finish_mmap_size);
-  if (!finish_mmap_buf)
-    return grub_errno;
-
-  if (grub_efi_get_memory_map (&finish_mmap_size, finish_mmap_buf, &finish_key,
-			       &finish_desc_size, &finish_desc_version) <= 0)
-    return grub_error (GRUB_ERR_IO, "couldn't retrieve memory map");
-
-  b = grub_efi_system_table->boot_services;
-  status = efi_call_2 (b->exit_boot_services, grub_efi_image_handle,
-		       finish_key);
-  if (status != GRUB_EFI_SUCCESS)
-    return grub_error (GRUB_ERR_IO, "couldn't terminate EFI services");
-
+  while (1)
+    {
+      if (grub_efi_get_memory_map (&finish_mmap_size, finish_mmap_buf, &finish_key,
+				   &finish_desc_size, &finish_desc_version) < 0)
+	return grub_error (GRUB_ERR_IO, "couldn't retrieve memory map");
+
+      if (outbuf && *outbuf_size < finish_mmap_size)
+	return grub_error (GRUB_ERR_IO, "memory map buffer is too small");
+
+      finish_mmap_buf = grub_malloc (finish_mmap_size);
+      if (!finish_mmap_buf)
+	return grub_errno;
+
+      if (grub_efi_get_memory_map (&finish_mmap_size, finish_mmap_buf, &finish_key,
+				   &finish_desc_size, &finish_desc_version) <= 0)
+	{
+	  grub_free (finish_mmap_buf);
+	  return grub_error (GRUB_ERR_IO, "couldn't retrieve memory map");
+	}
+
+      b = grub_efi_system_table->boot_services;
+      status = efi_call_2 (b->exit_boot_services, grub_efi_image_handle,
+			   finish_key);
+      if (status == GRUB_EFI_SUCCESS)
+	break;
+
+      if (status != GRUB_EFI_INVALID_PARAMETER)
+	{
+	  grub_free (finish_mmap_buf);
+	  return grub_error (GRUB_ERR_IO, "couldn't terminate EFI services");
+	}
+
+      grub_free (finish_mmap_buf);
+      grub_printf ("Trying to terminate EFI services again\n");
+    }
   grub_efi_is_finished = 1;
   if (outbuf_size)
     *outbuf_size = finish_mmap_size;

--=-qKDLrrS1szolY5Edu2H+--

