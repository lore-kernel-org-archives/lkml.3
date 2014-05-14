Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaENKzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:55:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbaENKy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:54:59 -0400
Message-ID: <53734B7D.4010504@redhat.com>
Date: Wed, 14 May 2014 11:54:53 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, suresh.b.siddha@intel.com
Subject: [PATCH v2] ptrace: Clarify PTRACE_GETREGSET/PTRACE_SETREGSET, documentation
 in uapi header
References: <1398682853-7541-1-git-send-email-khandual@linux.vnet.ibm.com> <53625681.8010905@redhat.com> <53670F35.6010502@linux.vnet.ibm.com> <53725FF6.6060004@redhat.com> <537316DB.4060701@linux.vnet.ibm.com>
In-Reply-To: <537316DB.4060701@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/14 08:10, Anshuman Khandual wrote:
> On 05/13/2014 11:39 PM, Pedro Alves wrote:
>> On 05/05/14 05:10, Anshuman Khandual wrote:
>>> On 05/01/2014 07:43 PM, Pedro Alves wrote:
>> OK, then this is what I suggest instead:
...
>>> Shall I resend the patch with the your proposed changes and your "Signed-off-by" and
>>> moving myself as "Reported-by" ?
>>
>> No idea of the actual policy to follow.  Feel free to do that if that's the
>> standard procedure.
> 
> Even I am not sure about this, so to preserve the correct authorship, would you
> mind sending this patch ?

Here you go.  This is against current Linus'.  Please take it from
here if necessary.

8<------------------------------------------
>From 1237f5ac5896f3910f66df83a5093bb548006188 Mon Sep 17 00:00:00 2001
From: Pedro Alves <palves@redhat.com>
Date: Wed, 14 May 2014 11:05:07 +0100
Subject: [PATCH] ptrace: Clarify PTRACE_GETREGSET/PTRACE_SETREGSET
 documentation in uapi header

The current comments don't explicitly state in plain words that
iov.len must be set to the buffer's length prior to the ptrace call.
A user might get confused and leave that uninitialized.

In the ptrace_regset function (snippet below) we see that the buffer
length has to be a multiple of the slot/register size for the given
NT_XXX_TYPE:

        if (!regset || (kiov->iov_len % regset->size) != 0)
                return -EINVAL;

Note regset->size is the size of each slot/register in the set, not
the size of the whole set.

And then, we see here:

 kiov->iov_len = min(kiov->iov_len,
                            (__kernel_size_t) (regset->n * regset->size));

that the kernel takes care of capping the requested length to the size
of the whole regset.

Signed-off-by: Pedro Alves <palves@redhat.com>
Reported-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 include/uapi/linux/ptrace.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index cf1019e..30836b9 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -39,12 +39,17 @@
  * payload are exactly the same layout.
  *
  * This interface usage is as follows:
- *	struct iovec iov = { buf, len};
+ *	struct iovec iov = { buf, len };
  *
  *	ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
  *
- * On the successful completion, iov.len will be updated by the kernel,
- * specifying how much the kernel has written/read to/from the user's iov.buf.
+ * On entry, iov describes the buffer's address and length.  The buffer's length
+ * must be a multiple of the size of a single register in the register set.  The
+ * kernel never reads or writes more than iov.len, and caps the buffer length to
+ * the register set's size.  In other words, the kernel reads or writes
+ * min(iov.len, regset size).  On successful completion, iov.len is updated by
+ * the kernel, specifying how much the kernel has read from / written to the
+ * user's iov.buf.
  */
 #define PTRACE_GETREGSET	0x4204
 #define PTRACE_SETREGSET	0x4205
-- 
1.9.0


