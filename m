Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3I0Rcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:32:36 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:45722 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753045Ab3I0Rcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:32:33 -0400
Message-ID: <5245C12E.6070608@hurleysoftware.com>
Date: Fri, 27 Sep 2013 13:32:30 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mikael Pettersson <mikpelinux@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Fix pty master read() after slave closes
References: <524493E6.60300@hurleysoftware.com> <1380302825-12539-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1380302825-12539-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 01:27 PM, Peter Hurley wrote:
> Commit f95499c3030fe1bfad57745f2db1959c5b43dca8,
>    n_tty: Don't wait for buffer work in read() loop
> creates a race window which can cause a pty master read()
> to miss the last pty slave write(s) and return -EIO instead,
> thus signalling the pty slave is closed. This can happen when
> the pty slave is written and immediately closed but before the
> tty buffer i/o loop receives the new input; the pty master
> read() is scheduled, sees its read buffer is empty and the
> pty slave has been closed, and exits.
>
> Because tty_flush_to_ldisc() has significant performance impact
> for parallel i/o, rather than revert the commit, special case this
> condition (ie., when the read buffer is empty and the 'other' pty
> has been closed) and, only then, wait for buffer work to complete
> before re-testing if the read buffer is still empty.
>
> As before, subsequent pty master reads return any available data
> until no more data is available, and then returns -EIO to
> indicate the pty slave has closed.
>
> Reported-by: Mikael Pettersson <mikpelinux@gmail.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

I tested this patch with the gcc ada ACATS testsuite and got this
summary so all seems ok with this patch.

		=== acats Summary ===
# of expected passes		805
# of unexpected failures	0

...

		=== acats Summary ===
# of expected passes		772
# of unexpected failures	0

...

		=== acats Summary ===
# of expected passes		743
# of unexpected failures	0

Mikael,

I'd appreciate if you could re-test with this patch and
confirm the issue is fixed.

Regards,
Peter Hurley
