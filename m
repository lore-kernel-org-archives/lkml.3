Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaJISqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 14:46:40 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:42720 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaJISqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 14:46:34 -0400
Date: Thu, 9 Oct 2014 14:46:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] fs: sysfs: return EFBIG on write if offset is
 larger than binary file size
Message-ID: <20141009184631.GA17554@mtj.dyndns.org>
References: <1412876515-12057-1-git-send-email-vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412876515-12057-1-git-send-email-vladimir_zapolskiy@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vladimir.

On Thu, Oct 09, 2014 at 08:41:55PM +0300, Vladimir Zapolskiy wrote:
> According to the user expectations common utilities like dd or sh
> redirection operator '>' should work correctly over binary files from
> sysfs. At the moment doing excessive write can not be ever completed
> (no error is returned), e.g. for 4-byte file:
> 
>   write(1, "\0\0\0\0\0\0\0\0", 8)         = 4
>   write(1, "\0\0\0\0", 4)                 = 0
>   write(1, "\0\0\0\0", 4)                 = 0
>   write(1, "\0\0\0\0", 4)                 = 0
>   write(1, "\0\0\0\0", 4)                 = 0
>   write(1, "\0\0\0\0", 4)                 = 0
>   .......
> 
> This is not a successful completion of write(2), so fix the problem by
> returning EFBIG as described in POSIX.1-2001:
> 
>   [EFBIG]
>     The file is a regular file, nbyte is greater than 0, and the
>     starting position is greater than or equal to the offset maximum
>     established in the open file description associated with fildes.
> 
> Note, the write(2) ABI is changed, however
> 1) write(2) behaviour is corrected in conformance to POSIX, the
>    existing userspace applications must be aware of possible errors on
>    a syscall,
> 2) the return value is changed on error path, so it is an exceptional
>    situation,
> 3) the change is related only to binary sysfs files, which is a very
>    small class of files, mainly representing non-volatile registers or
>    ram, eeproms etc, many of such files are read-only.
> 
> Presumably it is safe to apply the change, the described problem is
> definitely in the kernel and userspace utilities can not be changed to
> process 0 return value as an error, because it is just not an error
> according to POSIX.
> 
> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Tejun Heo <tj@kernel.org>

This is a bit risky but the current behavior is problematic and as you
pointed out the danger of actual breakge is relatively low.  We might
as well give it a shot.

 Cautiously-acked-by: Tejun Heo <tj@kernel.org>

Please also cc stable.

Thanks.

-- 
tejun
