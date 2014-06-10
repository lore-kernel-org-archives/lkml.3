Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbaFJGUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 02:20:16 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:42501 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbaFJGUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 02:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <1400165025-8688-1-git-send-email-meltedpianoman@gmail.com>
References: <1400165025-8688-1-git-send-email-meltedpianoman@gmail.com>
Date: Tue, 10 Jun 2014 08:20:14 +0200
Message-ID: <CAMSQXEGTH-RgSkB3ESbGSLr+kT4k8T64ybKUnyW7Uo3m=toP4Q@mail.gmail.com>
Subject: Re: [PATCH] [checkpatch.pl] Suspicious indentation detection after
 conditional statement
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
> Raise a SUSPICIOUS_CODE_INDENT warning when unexpected indentation is found
> after a conditional statement. This can be used to find missing braces or
> wrong indentation in/after a conditional statement.
>
> For example the following error is caught;
>
>         if (foo)
>                 bar();
>                 return;
>
> Which can be either intended by the programmer as:
>
>         if (foo)
>                 bar();
>         return;
>
> or
>         if (foo) {
>                 bar();
>                 return;
>         }
>
> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
> ---
>
> Request for comments:
> I think this is a nice warning to have, since you can get into a buggy situation
> when you want to add extra statements to a one line condition, but you forget
> to add the {} around the multiline statement block.
>
>  scripts/checkpatch.pl |   41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index e7bca89..3ca3923 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2565,6 +2565,47 @@ sub process {
>                                 WARN("SUSPECT_CODE_INDENT",
>                                      "suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");
>                         }
> +
> +# Also check if the next statement after the previous condition has the same indent
> +                       my ($stat_next, undef, $line_nr_next_next) =
> +                               ctx_statement_block($line_nr_next, $remain_next, $off_next);
> +                       my $s_next = $stat_next;
> +
> +                       # Remove line prefixes
> +                       $s_next =~ s/\n./\n/gs;
> +
> +                       # Remove any comments
> +                       $s_next =~ s/$;//g;
> +
> +                       # Skip this check for in case next statement starts with 'else'
> +                       if ($s_next !~ /\s*\belse\b/) {
> +
> +                               # Remove while that belongs to a do {} while
> +                               if ($stat =~ /\bdo\b/) {
> +                                       $s_next =~ s/^.*\bwhile\b\s*($balanced_parens)\s*?//;
> +                               }
> +
> +                               # Remove blank lines
> +                               $s_next =~ s/\s*\\?\n//g;
> +
> +                               # Get the real next lines
> +                               my $next_nof_lines = $line_nr_next_next - $line_nr_next;
> +                               my $stat_next_real = raw_line($line_nr_next, $next_nof_lines);
> +                               if (!defined($stat_next_real)) {
> +                                       $stat_next_real = "";
> +                               } elsif ($next_nof_lines > 1) {
> +                                       $stat_next_real = "[...]\n$stat_next_real";
> +                               }
> +                               my (undef, $nindent) = line_stats('+' . $s_next);
> +
> +                               #print "stat_next<$stat_next> stat<$stat> indent<$indent> nindent<$nindent> s_next<$s_next> stat_next_real<$stat_next_real>\n";
> +
> +                               if ($nindent > $indent) {
> +                                       WARN("SUSPICIOUS_CODE_INDENT",
> +                                            "suspicious code indentation after conditional statements\n" .
> +                                            $herecurr . "$stat_real\n$stat_next_real\n");
> +                               }
> +                       }
>                 }
>
>                 # Track the 'values' across context and added lines.
> --
> 1.7.9.5
>
