Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbaHYXLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:11:34 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38695 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133AbaHYXLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:11:33 -0400
X-Sasl-enc: UXr7xAUXAopsPQajB63M37+iUAhpZusClVxhiB4DIBQO 1409008291
Message-ID: <1409008290.6274.73.camel@localhost>
Subject: Re: [PATCH] random: add and use memzero_explicit() for clearing data
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: tytso@mit.edu, zatimend@hotmail.co.uk, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Date: Tue, 26 Aug 2014 01:11:30 +0200
In-Reply-To: <1408996899-4892-1-git-send-email-dborkman@redhat.com>
References: <1408996899-4892-1-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 2014-08-25 at 22:01 +0200, Daniel Borkmann wrote:
> zatimend has reported that in his environment (3.16/gcc4.8.3/corei7)
> memset() calls which clear out sensitive data in extract_{buf,entropy,
> entropy_user}() in random driver are being optimized away by gcc.
> 
> Add a helper memzero_explicit() (similarly as explicit_bzero() variants)
> that can be used in such cases where a variable with sensitive data is
> being cleared out in the end. Other use cases might also be in crypto
> code. [ I have put this into lib/string.c though, as it's always built-in
> and doesn't need any dependencies then. ]
> 
> Fixes kernel bugzilla: 82041
> 
> Reported-by: zatimend@hotmail.co.uk
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

In case this pattern of important function calls getting optimized away
emerges more often we could also go with a wrapper which forces the
execution of the function, like:

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -181,6 +181,13 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #define OPTIMIZER_HIDE_VAR(var) barrier()
 #endif
 
+#ifndef OPTIMIZER_FORCE_CALL
+#define OPTIMIZER_FORCE_CALL(func, args...) ({                         \
+                       typeof(func) * volatile __func = (func);        \
+                       __func(args);                                   \
+               })
+#endif
+
 /* Not-quite-unique ID. */
 #ifndef __UNIQUE_ID
 # define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __LINE__)


Thanks,
Hannes


