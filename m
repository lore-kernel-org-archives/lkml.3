Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3IPRVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:21:33 -0400
Received: from science.horizon.com ([71.41.210.146]:13273 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751104Ab3IPRVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:21:32 -0400
Date: 16 Sep 2013 13:21:31 -0400
Message-ID: <20130916172131.8282.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: joe@perches.com, keescook@chromium.org
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, JBeulich@suse.com,
        kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux@horizon.com, penguin-kernel@i-love.sakura.ne.jp,
        viro@zeniv.linux.org.uk
In-Reply-To: <1379344187.1934.1.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My thought was to add a seq_last_len()

In addition to adding per-call overhead to support a rarely-used feature
(while ->pos comes for free), this has the downside that it matters how
many separate calls are used to generate the string.

The advantage of the "read ->pos before and after" technique is that
you can have an arbitrary number of output calls in between.
Including things like seq_path(), seq_bitmap(), etc.

If you have the printing done in a subroutine (as in the net/ipv4
directory), it would be annoyingly subtle if seq_puts("foobar")
were not equivalent to seq_puts("foo"); seq_puts("bar").


I agree that exposing the internals via ->pos is a bit ugly, but too
many levels of abstraction makes code hard to read, too, and it's very
straightforward to find and fix the dozen or so places where it's accessed
in the unlikely case that the internals of seq_file change significantly.

My take on it is "not worth fixing".
