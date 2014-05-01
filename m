Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaEAON1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:13:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbaEAON0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:13:26 -0400
Message-ID: <53625681.8010905@redhat.com>
Date: Thu, 01 May 2014 15:13:21 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, suresh.b.siddha@intel.com
Subject: Re: [PATCH] ptrace: Fix PTRACE_GETREGSET/PTRACE_SETREGSET in code
 documentation
References: <1398682853-7541-1-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1398682853-7541-1-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 12:00 PM, Anshuman Khandual wrote:
> The current documentation is bit misleading and does not explicitly
> specify that iov.len need to be initialized failing which kernel
> may just ignore the ptrace request and never read from/write into
> the user specified buffer. This patch fixes the documentation.

Well, it kind of does, here:

*      struct iovec iov = { buf, len};

> @@ -43,8 +43,12 @@
>   *
>   *	ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
>   *
> - * On the successful completion, iov.len will be updated by the kernel,
> - * specifying how much the kernel has written/read to/from the user's iov.buf.
> + * A non-zero value upto the max size of data expected to be written/read by the
> + * kernel in response to any NT_XXX_TYPE request type must be assigned to iov.len
> + * before initiating the ptrace call. If iov.len is 0, then kernel will neither
> + * read from or write into the user buffer specified. On successful completion,
> + * iov.len will be updated by the kernel, specifying how much the kernel has
> + * written/read to/from the user's iov.buf.

I really appreciate that you're trying to make this clearer, but I
find the new sentence very hard to read/reason.  :-/

I suggest:

 * This interface usage is as follows:
- *      struct iovec iov = { buf, len};
+ *      struct iovec iov = { buf, len };
 *
 *      ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
 *
- * On the successful completion, iov.len will be updated by the kernel,
- * specifying how much the kernel has written/read to/from the user's iov.buf.
+ * On entry, iov describes the buffer's address and length.  The buffer's
+ * length must be equal to or shorter than the size of the NT_XXX_TYPE regset.
+ * On successful completion, iov.len is updated by the kernel, specifying how
+ * much the kernel has written/read to/from the user's iov.buf.

I'm not sure I understood what you're saying correctly, though.  Specifically,
I don't know whether the buffer's length must really be shorter than the
size of the NT_XXX_TYPE regset.

> The current documentation is bit misleading and does not explicitly
> specify that iov.len need to be initialized failing which kernel
> may just ignore the ptrace request and never read from/write into
> the user specified buffer.

You're saying that if iov.len is larger than the NT_XXX_TYPE regset,
then the kernel returns _success_, but actually doesn't fill the
buffer?  That sounds like a bug to me.

-- 
Pedro Alves

