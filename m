Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbaHYSiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:38:51 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33588 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaHYSiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140825102932.GA5772@amd>
References: <72714b6b69d00496d6e55453423c4070de292bf4.1408724662.git.luto@amacapital.net>
 <20140825102932.GA5772@amd>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 25 Aug 2014 11:38:28 -0700
Message-ID: <CALCETrVk82563HWRYdX0a75usssLE=F_jM=vhTKL0y0xr9eEsg@mail.gmail.com>
Subject: Re: [PATCH v2] checkpatch.pl: New instances of ENOSYS are errors
To: Pavel Machek <pavel@ucw.cz>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 25, 2014 3:29 AM, "Pavel Machek" <pavel@ucw.cz> wrote:
>
> On Fri 2014-08-22 09:26:31, Andy Lutomirski wrote:
> > ENOSYS means that a nonexistent system call was called.  We have a
> > bad habit of using it for things like invalid operations on
> > otherwise valid syscalls.  We should avoid this in new code.
>
> Is it good idea? I mean, doing EINVAL for subcalls is pretty
> unhelpful.

EOPNOTSUPP?

The problem is that user code wants to do:

bool foo_wrapper(int op)
{
  if (foo_not_supported)
    return false

  if (foo(op) != 0) {
    if (errno == ENOSYS)
      foo_not_supported = true;
    return false;
  }

  return true;
}

foo_wrapper(FOO_OP_A);
foo_wrapper(FOO_OP_B);

If FOO_OP_A returns -ENOSYS but FOO_OP_B does not, then this doesn't work.

--Andy
