Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaIDKnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:43:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60471 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaIDKnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:43:20 -0400
Message-ID: <54084246.7010705@arm.com>
Date: Thu, 04 Sep 2014 11:43:18 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 01/11] cpumask: factor out show_cpumap into separate
 helper function
References: <1409763617-17074-1-git-send-email-sudeep.holla@arm.com> <1409763617-17074-2-git-send-email-sudeep.holla@arm.com> <20140904062006.GC3190@worktop.ger.corp.intel.com> <54082ADD.6040004@arm.com> <20140904092135.GA346@worktop.programming.kicks-ass.net>
In-Reply-To: <20140904092135.GA346@worktop.programming.kicks-ass.net>
X-OriginalArrivalTime: 04 Sep 2014 10:43:15.0936 (UTC) FILETIME=[0889B600:01CFC82D]
X-MC-Unique: 114090411431704701
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 04/09/14 10:21, Peter Zijlstra wrote:
> On Thu, Sep 04, 2014 at 10:03:25AM +0100, Sudeep Holla wrote:
>> If I don't, every file including this header generates "warning:
>> ‘cpumap_copy_to_buf’ defined but not used". Alternatively I can just
>> declare here and define it elsewhere but I could not find more apt
>> place than this. Any suggestions ? kernel/cpu.c ?
>
> Sure the tail of cpu.c seems to have various other cpumask gunk in
> already so it fits there. The other alternative would've been
> lib/bitmap.c since that's where the various bitmap printf
> implementations live.
>
> You could make it bitmap_copy_to_buf() I suppose, and then have a
> cpumask inline wrapper, to be fully consistent with the rest of the
> implementations.
>

I liked the second approach, how about patch below ?
If will munge it into original patch.

--->8

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index e1c8d080c427..34586d386c1f 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -60,6 +60,7 @@
    * bitmap_find_free_region(bitmap, bits, order)        Find and 
allocate bit region
    * bitmap_release_region(bitmap, pos, order)   Free specified bit region
    * bitmap_allocate_region(bitmap, pos, order)  Allocate specified bit 
region
+ * bitmap_copy_to_pagebuf(list, src, buf)      Print bitmap src as 
list/hex to buf
    */

   /*
@@ -145,6 +146,8 @@ extern void bitmap_release_region(unsigned long 
*bitmap, unsigned int pos, int o
   extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int 
pos, int order);
   extern void bitmap_copy_le(void *dst, const unsigned long *src, int 
nbits);
   extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int 
bits);
+extern int bitmap_copy_to_pagebuf(bool list, const unsigned long *maskp,
+                                 char *buf);

   #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
   #define BITMAP_LAST_WORD_MASK(nbits)                                   \
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 26d8348292dd..5b3bd163c5a0 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -807,16 +807,7 @@ static inline const struct cpumask 
*get_cpu_mask(unsigned int cpu)
   static inline ssize_t
   cpumap_copy_to_buf(bool list, const struct cpumask *mask, char *buf)
   {
-       ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf - 2;
-       int n = 0;
-
-       if (len > 1) {
-               n = list ? cpulist_scnprintf(buf, len, mask) :
-                          cpumask_scnprintf(buf, len, mask);
-               buf[n++] = '\n';
-               buf[n] = '\0';
-       }
-       return n;
+       return bitmap_copy_to_pagebuf(list, cpumask_bits(mask), buf);
   }

sudeep@e103737-lin:~/work/power/kernel$ git diff > /tmp/log
sudeep@e103737-lin:~/work/power/kernel$ cat /tmp/log
diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index e1c8d080c427..34586d386c1f 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -60,6 +60,7 @@
    * bitmap_find_free_region(bitmap, bits, order)	Find and allocate bit 
region
    * bitmap_release_region(bitmap, pos, order)	Free specified bit region
    * bitmap_allocate_region(bitmap, pos, order)	Allocate specified bit 
region
+ * bitmap_copy_to_pagebuf(list, src, buf)	Print bitmap src as list/hex 
to buf
    */

   /*
@@ -145,6 +146,8 @@ extern void bitmap_release_region(unsigned long 
*bitmap, unsigned int pos, int o
   extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int 
pos, int order);
   extern void bitmap_copy_le(void *dst, const unsigned long *src, int 
nbits);
   extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int 
bits);
+extern int bitmap_copy_to_pagebuf(bool list, const unsigned long *maskp,
+				  char *buf);

   #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
   #define BITMAP_LAST_WORD_MASK(nbits)					\
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 26d8348292dd..5b3bd163c5a0 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -807,16 +807,7 @@ static inline const struct cpumask 
*get_cpu_mask(unsigned int cpu)
   static inline ssize_t
   cpumap_copy_to_buf(bool list, const struct cpumask *mask, char *buf)
   {
-	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf - 2;
-	int n = 0;
-
-	if (len > 1) {
-		n = list ? cpulist_scnprintf(buf, len, mask) :
-			   cpumask_scnprintf(buf, len, mask);
-		buf[n++] = '\n';
-		buf[n] = '\0';
-	}
-	return n;
+	return bitmap_copy_to_pagebuf(list, cpumask_bits(mask), buf);
   }

   /*
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1e031f2c9aba..b23adef04d7e 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -580,6 +580,32 @@ int bitmap_scnlistprintf(char *buf, unsigned int 
buflen,
   EXPORT_SYMBOL(bitmap_scnlistprintf);

   /**
+ * bitmap_copy_to_pagebuf - convert bitmap to list or hex format ASCII 
string
+ * @list: indicates whether the bitmap must be list
+ * @maskp: pointer to bitmap to convert
+ * @buf: page aligned buffer into which string is placed
+ *
+ * Output format is a comma-separated list of decimal numbers and
+ * ranges if list is specified or hex digits grouped into comma-separated
+ * sets of 8 digits/set. Returns the number of characters written to buf.
+ */
+int bitmap_copy_to_pagebuf(bool list, const unsigned long *maskp, char 
*buf)
+{
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf - 2;
+	int n = 0;
+
+	if (len > 1) {
+		n = list ?
+		    bitmap_scnlistprintf(buf, len, maskp, nr_cpumask_bits) :
+		    bitmap_scnprintf(buf, len, maskp, nr_cpumask_bits);
+		buf[n++] = '\n';
+		buf[n] = '\0';
+	}
+	return n;
+}
+EXPORT_SYMBOL(bitmap_copy_to_pagebuf);
+
+/**
    * __bitmap_parselist - convert list format ASCII string to bitmap
    * @buf: read nul-terminated user string from this buffer
    * @buflen: buffer size in bytes.  If string is smaller than this

