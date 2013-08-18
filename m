Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3HRKCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 06:02:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38283 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab3HRKCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 06:02:50 -0400
Date: Sun, 18 Aug 2013 12:02:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Youquan Song <youquan.song@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Youquan Song <youquan.song@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Message-ID: <20130818100247.GB26728@pd.tnic>
References: <CAE9FiQWbVDRpLUCUTF=Jpmm-nn6kgBYFW25PPTEiPK-R-mX0jA@mail.gmail.com>
 <20130729170514.GB30371@linux-youquan.bj.intel.com>
 <20130814184040.GA6726@linux-youquan.bj.intel.com>
 <20130814111105.GA13772@gmail.com>
 <20130817134454.GA16835@linux-youquan.bj.intel.com>
 <20130817074256.GA18772@gmail.com>
 <20130817082419.GA10005@pd.tnic>
 <1376730231.1954.7.camel@joe-AO722>
 <20130817154447.GB10005@pd.tnic>
 <1376756803.2027.7.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1376756803.2027.7.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 09:26:43AM -0700, Joe Perches wrote:
> > ... unless there's a way to detect new submissions and scream only
> > for those. I.e., look at lines starting with "+" which don't have
> > corresponding "-" lines.
> 
> No, that's not the right way to do that.
> That bit's relatively easy because checkpatch only looks
> at files when there's a specific command line -f flag.
> So just check the existence of the -f command line flag
> (!$file) and for an added comment that starts "/* foo" without
> a comment termination */ after it on the same line.

Right, your way is simpler.

> > This would need a bit of experimenting and is not trivial though, maybe
> > Algorithm::Diff could even help there.
> > 
> > Sounds like a mini-project for a perl dude :-)
> 
> I'm not one of those...
> 
> This might work though
> 
>  scripts/checkpatch.pl | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 9ba4fc4..abe820a 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2119,6 +2119,15 @@ sub process {
>  			}
>  		}
>  
> +		if (!$file &&
> +		    $realfile !~ m@^(drivers/net/|net/)@ &&
> +		    $rawline =~ /^\+/ &&	#Added line
> +		    $rawline !~ m@/\*.*\*/@ &&	#whole comments
> +		    $rawline =~ m@/\*+.+@) {	#unterminated comment
> +			WARN("COMMENT_STYLE",
> +			     "block comments use an empty /* line\n" . $herecurr);
> +		}
> +
>  		if ($realfile =~ m@^(drivers/net/|net/)@ &&
>  		    $prevrawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
>  		    $rawline =~ /^\+[ \t]*\*/) {

Almost. It needs to look only on *.[ch] files because otherwise it fires on that
	very same diff to checkpatch.pl too:

$ git diff | ./scripts/checkpatch.pl -

...

WARNING: block comments use an empty /* line
#15: FILE: scripts/checkpatch.pl:2059:
+                            "block comments use an empty /* line\n" . $herecurr);


Also, we need to catch this obvious case:

        /*
         * This is a wrong comment. */


IOW, something like a modified version of yours below. It doesn't catch
every wrong comment form out there but it should be a start.

--
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2ee9eb750560..111b6615d74d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2050,6 +2050,16 @@ sub process {
 			}
 		}
 
+		if (!$file &&
+		    $realfile !~ m@^(drivers/net/|net/)@ &&
+		    $rawline =~ /^\+/ &&		# Added line
+		    $rawline !~ m@/\*.*\*/@ &&		# whole comments
+		    ($rawline =~ m@/\*+.+@ ||		# unterminated opening
+		     $rawline =~ m@\s*\*+.+\*+/@)) {	# unterminated closing
+			WARN("COMMENT_STYLE",
+			     "Multi-line comments use an empty /* opening and */ closing line\n" . $herecurr);
+		}
+
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
 		    $prevrawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
 		    $rawline =~ /^\+[ \t]*\*/) {

--

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
