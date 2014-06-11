Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaFKJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:16:59 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:61058 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaFKJQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:16:44 -0400
Date: Wed, 11 Jun 2014 10:16:40 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [checkpatch.pl] ctx_statement_block #if/#else/#endif fix
Message-ID: <20140611091640.GK6819@bark>
References: <1400164995-8652-1-git-send-email-meltedpianoman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400164995-8652-1-git-send-email-meltedpianoman@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 04:43:15PM +0200, Ivo Sieben wrote:
> When picking up a complete statement block #if/#else/#endif prepocesor
> boundaries are taken into account by pushing current level & type on a stack.
> But on an #else the level was read from stack again (without actually popping it
> from stack) causing the statement block to end too early on the next ';'.
> Fixed this.
> 
> For example the following code:
> 
>  	if (!test()) {
>  #ifdef NEVER
>  		foo();
>  		bar();
>  #else
>  		bar();
>  		foo();
>  #endif
>  	}
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
>  		if ($remainder =~ /^#\s*(?:ifndef|ifdef|if)\s/) {
>  			push(@stack, [ $type, $level ]);
>  		} elsif ($remainder =~ /^#\s*(?:else|elif)\b/) {
> -			($type, $level) = @{$stack[$#stack - 1]};
> +			# no changes to stack: type & level remain the same
>  		} elsif ($remainder =~ /^#\s*endif\b/) {
>  			($type, $level) = @{pop(@stack)};
>  		}
> @@ -1050,7 +1050,7 @@ sub ctx_block_get {
>  		if ($lines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
>  			push(@stack, $level);
>  		} elsif ($lines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
> -			$level = $stack[$#stack - 1];
> +			# no changes to stack: type & level remain the same
>  		} elsif ($lines[$line] =~ /^.\s*#\s*endif\b/) {
>  			$level = pop(@stack);
>  		}
> -- 
> 1.7.9.5

It doesn't seem right to remove the restore of the state.  If you
consider the effect of an #if/#else/#endif combination the state of the
statement parser should be reset to the state at #if at the #else as the
code there is an alternative for the code in the other branch(s) of the
preprocessor, either is a continuation of the statement in progress when
reached.  This contrived example should make it clear we need to
restore:

	c = (d +
#if A
	a)
#else
	b)
#endif


That said it appears to be doing something wrong in your example.

/me will have a poke and get back to you.

-apw

