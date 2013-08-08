Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab3HHFFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:05:45 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:48026 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3HHFFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:05:42 -0400
MIME-Version: 1.0
In-Reply-To: <52031EAE.5080005@linux.vnet.ibm.com>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
	<51FA3B02.7060004@linux.vnet.ibm.com>
	<3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com>
	<CA+8MBbLuhVDCb26ag3AH0vXrP4MXHLxS5aVn8pTi4=qL1NdR5w@mail.gmail.com>
	<CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com>
	<51FFDC8B.7010909@linux.vnet.ibm.com>
	<CA+8MBb+1LpR+Cx=84WZT98U5eqZcm1KriUP75aCg+uSrXrb3Yw@mail.gmail.com>
	<51FFFFEB.3030907@linux.vnet.ibm.com>
	<CA+8MBbK9oZJO+RJGC-7riO=Kz=UbRcAvQ-nDi=2GLyvEDpoc7g@mail.gmail.com>
	<CA+8MBbKA+P4vs3utSKQ-LPMW3ybrWOp=f3FH6ahv1YtwnMm5KA@mail.gmail.com>
	<5201A9BD.4090503@linux.vnet.ibm.com>
	<CA+8MBbJS0Dymn4OABi-rW9M5Bw-ZZ6DaEjQOW-oki+4ge4BDtg@mail.gmail.com>
	<5201D777.8060303@linux.vnet.ibm.com>
	<CA+8MBb+pkKpaEDs6J_XbzM3wzady2MjdU+jcDP+jH1f1VBxG5w@mail.gmail.com>
	<CA+8MBb+dNkT_xpqL6oy=D3UqCtEwAci5fatw-0crCFLMAGE1nA@mail.gmail.com>
	<52031EAE.5080005@linux.vnet.ibm.com>
Date: Wed, 7 Aug 2013 22:05:41 -0700
Message-ID: <CA+8MBb+7Q9MHzGxQv+_an5C2-5P9N7tRvYpE3ran-0TcE5pScQ@mail.gmail.com>
Subject: Re: [PATCH 00/11] Add compression support to pstore
From: Tony Luck <tony.luck@gmail.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 9:29 PM, Aruna Balakrishnaiah
<aruna@linux.vnet.ibm.com> wrote:
> When we preallocate, we can use the same big_buf for compression as well as
> decompression.
> Also workspace will be one for both. By allocating max of inflate workspace
> size and deflate
> workspace size. We can save memory here.

Well decompression isn't a problem. We are doing that in the non-panicing
context of the freshly booted kernel so we can allocate memory without any
worries for this.  It's only the compression during panic where we must
pre-allocate.  But if the sizes are close to the same, then we might as well
use the same buffers for both (and simplify the code because we don't have
to worry about the kmalloc/kfree bits.

> If pre-allocating close to 50k of buffer is not a issue. We can go ahead
> with this approach.

I never care about allocations measured in *kilo*bytes[1] - the smallest systems
I use have 32GB - so 50K is so far down in the noise of other allocations.
But other types of systems might be more concerned.  ERST is generally
only implemented on servers ... so the better question might be:
What are the sizes for the EFI backend (where the buffer size is 1024). It
sounds like it should scale linearly ... so below 8K???  That should not
scare many people. Even phones measure memory in hundreds of MBytes.

-Tony

[1] unless they are per-cpu or per something else that there are a lot of
on a big server - but this is a one-per-system allocation.
