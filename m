Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3HQQ0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 12:26:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42151 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753657Ab3HQQ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 12:26:44 -0400
Message-ID: <1376756803.2027.7.camel@joe-AO722>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>,
        Youquan Song <youquan.song@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Youquan Song <youquan.song@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 17 Aug 2013 09:26:43 -0700
In-Reply-To: <20130817154447.GB10005@pd.tnic>
References: <CAE9FiQVDZGbTEd7jpmOQY9+_Gb=DRrd=CCmvQPqXWoyww2NjdQ@mail.gmail.com>
	 <20130724062254.GA16400@redhat.com>
	 <CAE9FiQWbVDRpLUCUTF=Jpmm-nn6kgBYFW25PPTEiPK-R-mX0jA@mail.gmail.com>
	 <20130729170514.GB30371@linux-youquan.bj.intel.com>
	 <20130814184040.GA6726@linux-youquan.bj.intel.com>
	 <20130814111105.GA13772@gmail.com>
	 <20130817134454.GA16835@linux-youquan.bj.intel.com>
	 <20130817074256.GA18772@gmail.com> <20130817082419.GA10005@pd.tnic>
	 <1376730231.1954.7.camel@joe-AO722> <20130817154447.GB10005@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-17 at 17:44 +0200, Borislav Petkov wrote:
> On Sat, Aug 17, 2013 at 02:03:51AM -0700, Joe Perches wrote:
> > checkpatch tends to be used for firs patch submissions and
> > adding it would only encourage a new wave of trivial whitespace
> > patches.
> 
> Nope, we definitely don't want that...
> 
> > I think there are already way, _way_ too many existing instances
> > of comments that are of the form
> > 	/* foo
> > 	 * ...
> > to add that.
> > 
> > There are 10s of thousands outside of net/ and drivers/net/.
> 
> ... unless there's a way to detect new submissions and scream only
> for those. I.e., look at lines starting with "+" which don't have
> corresponding "-" lines.

No, that's not the right way to do that.
That bit's relatively easy because checkpatch only looks
at files when there's a specific command line -f flag.
So just check the existence of the -f command line flag
(!$file) and for an added comment that starts "/* foo" without
a comment termination */ after it on the same line.

> This would need a bit of experimenting and is not trivial though, maybe
> Algorithm::Diff could even help there.
> 
> Sounds like a mini-project for a perl dude :-)

I'm not one of those...

This might work though

 scripts/checkpatch.pl | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9ba4fc4..abe820a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2119,6 +2119,15 @@ sub process {
 			}
 		}
 
+		if (!$file &&
+		    $realfile !~ m@^(drivers/net/|net/)@ &&
+		    $rawline =~ /^\+/ &&	#Added line
+		    $rawline !~ m@/\*.*\*/@ &&	#whole comments
+		    $rawline =~ m@/\*+.+@) {	#unterminated comment
+			WARN("COMMENT_STYLE",
+			     "block comments use an empty /* line\n" . $herecurr);
+		}
+
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
 		    $prevrawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
 		    $rawline =~ /^\+[ \t]*\*/) {


