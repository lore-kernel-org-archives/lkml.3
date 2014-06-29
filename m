Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaF2CwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 22:52:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaF2CwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 22:52:19 -0400
Message-ID: <53AF7F63.9080807@infradead.org>
Date: Sat, 28 Jun 2014 19:52:19 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Horia Geanta <horia.geanta@freescale.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/kernel-doc: handle object-like macros
References: <1403525732-7653-1-git-send-email-horia.geanta@freescale.com>
In-Reply-To: <1403525732-7653-1-git-send-email-horia.geanta@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/14 05:15, Horia Geanta wrote:
> Object-like macros are different than function-like macros:
> https://gcc.gnu.org/onlinedocs/cpp/Object-like-Macros.html
> https://gcc.gnu.org/onlinedocs/cpp/Function-like-Macros.html
> 
> They are not parsed correctly, generating invalid intermediate
> files (xmls) for cases like:
>     #define BIT_MASK    (0xFF << BIT_SHIFT)
> where "OxFF <<" is considered to be parameter type.
> 
> When parsing, we can differentiate beween these two types of macros by
> checking whether there is at least one whitespace b/w "#define" and
> first opening paranthesis.

                parenthesis.

Where did you see a problem?  I tested the patch and all of the
Documentation/DocBook/*.xml files are the same without or with the patch.


> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> ---
>  scripts/kernel-doc | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index da058da413e7..ffd35c9d616a 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -2073,6 +2073,7 @@ sub check_return_section {
>  sub dump_function($$) {
>      my $prototype = shift;
>      my $file = shift;
> +    my $noret = 0;
>  
>      $prototype =~ s/^static +//;
>      $prototype =~ s/^extern +//;
> @@ -2086,7 +2087,7 @@ sub dump_function($$) {
>      $prototype =~ s/__init_or_module +//;
>      $prototype =~ s/__must_check +//;
>      $prototype =~ s/__weak +//;
> -    $prototype =~ s/^#\s*define\s+//; #ak added
> +    my $define = $prototype =~ s/^#\s*define\s+//; #ak added
>      $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
>  
>      # Yes, this truly is vile.  We are looking for:
> @@ -2105,7 +2106,15 @@ sub dump_function($$) {
>      # - atomic_set (macro)
>      # - pci_match_device, __copy_to_user (long return type)
>  
> -    if ($prototype =~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
> +    if ($define && $prototype =~ m/^()([a-zA-Z0-9_~:]+)\s+/) {
> +        # This is an object-like macro, it has no return type and no parameter
> +        # list.
> +        # Function-like macros are not allowed to have spaces between
> +        # declaration_name and opening paranthesis (notice the \s+).
> +        $return_type = $1;
> +        $declaration_name = $2;
> +        $noret = 1;
> +    } elsif ($prototype =~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
>  	$prototype =~ m/^(\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
>  	$prototype =~ m/^(\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
>  	$prototype =~ m/^(\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
> @@ -2140,7 +2149,7 @@ sub dump_function($$) {
>          # of warnings goes sufficiently down, the check is only performed in
>          # verbose mode.
>          # TODO: always perform the check.
> -        if ($verbose) {
> +        if ($verbose && !$noret) {
>                  check_return_section($file, $declaration_name, $return_type);
>          }
>  
> 


-- 
~Randy
