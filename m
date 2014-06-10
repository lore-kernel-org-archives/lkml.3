Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaFJGTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 02:19:49 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:38634 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaFJGTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 02:19:48 -0400
MIME-Version: 1.0
In-Reply-To: <1400164995-8652-1-git-send-email-meltedpianoman@gmail.com>
References: <1400164995-8652-1-git-send-email-meltedpianoman@gmail.com>
Date: Tue, 10 Jun 2014 08:19:47 +0200
Message-ID: <CAMSQXEE9ZgE8wuXz_qu5ndbfFne7zjhN24R44trPE11e02hmWQ@mail.gmail.com>
Subject: Re: [PATCH] [checkpatch.pl] ctx_statement_block #if/#else/#endif fix
From: Ivo Sieben <meltedpianoman@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>
Cc: Ivo Sieben <meltedpianoman@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy, Joe,

What do you think about my patchset below?

Regards,
Ivo Sieben

2014-05-15 16:43 GMT+02:00 Ivo Sieben <meltedpianoman@gmail.com>:
> When picking up a complete statement block #if/#else/#endif prepocesor
> boundaries are taken into account by pushing current level & type on a stack.
> But on an #else the level was read from stack again (without actually popping it
> from stack) causing the statement block to end too early on the next ';'.
> Fixed this.
>
> For example the following code:
>
>         if (!test()) {
>  #ifdef NEVER
>                 foo();
>                 bar();
>  #else
>                 bar();
>                 foo();
>  #endif
>         }
>
> Results in statement block:
>
>  STATEMENT<+    if (!test()) {
>  +#ifdef NEVER
>  +              foo();
>  +              bar();
>  +#else
>  +              bar();>
>  CONDITION<+    if (!test())>
>
> While you would expect:
>
>  STATEMENT<+    if (!test()) {
>  +#ifdef NEVER
>  +              foo();
>  +              bar();
>  +#else
>  +              bar();
>  +              foo();
>  +#endif
>  +       }>
>  CONDITION<+     if (!test())>
>
> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
> ---
>
> Request for comments:
> I think I fixed a problem here that I encountered while I was working on another
> changeset in which I check the statement block after a condition.
> Somehow the statement block did not contain everything I expected.
>
>  scripts/checkpatch.pl |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 34eb216..e7bca89 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -878,7 +878,7 @@ sub ctx_statement_block {
>                 if ($remainder =~ /^#\s*(?:ifndef|ifdef|if)\s/) {
>                         push(@stack, [ $type, $level ]);
>                 } elsif ($remainder =~ /^#\s*(?:else|elif)\b/) {
> -                       ($type, $level) = @{$stack[$#stack - 1]};
> +                       # no changes to stack: type & level remain the same
>                 } elsif ($remainder =~ /^#\s*endif\b/) {
>                         ($type, $level) = @{pop(@stack)};
>                 }
> @@ -1050,7 +1050,7 @@ sub ctx_block_get {
>                 if ($lines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
>                         push(@stack, $level);
>                 } elsif ($lines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
> -                       $level = $stack[$#stack - 1];
> +                       # no changes to stack: type & level remain the same
>                 } elsif ($lines[$line] =~ /^.\s*#\s*endif\b/) {
>                         $level = pop(@stack);
>                 }
> --
> 1.7.9.5
>
