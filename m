Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3IXPph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:45:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54859 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3IXPpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:45:35 -0400
Date: Tue, 24 Sep 2013 08:45:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: False positive in checkpatch
Message-ID: <20130924154529.GD9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130923225949.GA26278@linux.vnet.ibm.com>
 <1379996467.3575.67.camel@joe-AO722>
 <20130924140305.GZ9093@linux.vnet.ibm.com>
 <20130924151329.GL13914@dm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924151329.GL13914@dm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092415-8236-0000-0000-0000020C7827
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 04:13:29PM +0100, Andy Whitcroft wrote:
> On Tue, Sep 24, 2013 at 07:03:05AM -0700, Paul E. McKenney wrote:
> > On Mon, Sep 23, 2013 at 09:21:07PM -0700, Joe Perches wrote:
> > > On Mon, 2013-09-23 at 15:59 -0700, Paul E. McKenney wrote:
> > > > Hello!
> > > > 
> > > > The checkpatch.pl script complains as follows:
> > > > 
> > > > ERROR: need consistent spacing around '*' (ctx:WxB)
> > > > #57: FILE: include/linux/rcupdate.h:564:
> > > > +		ACCESS_ONCE(p) = (typeof(*(v)) __force space *)(v); \
> > > > 
> > > > Of course, the two uses of '*' are doing different things, so it should
> > > > be OK for the spacing to be different.
> > > > 
> > > > Could you please fix this?
> > > > 
> > > > 							Thanx, Paul
> > > > 
> > > 
> > > Hi Paul.
> > > 
> > > Try this patch: https://lkml.org/lkml/2013/9/2/428
> > > 
> > > Andy?  Can you verify this suggested patch please?
> > 
> > That does it, thank you!  And it does look like this patch was directed
> > precisely at this patch.  ;-)
> > 
> > 							Thanx, Paul
> > 
> 
> How about this one, it is a bit of a hack but does at least correctly
> correct the formal characterisation of the operator to unary.
> 
> Working on getting this tested a bit better before sending it out
> formally.

Works for me!

							Thanx, Paul

> -apw
> 
> 
> >From 5b4e22c123b3492838d12181129a8c168598dbf4 Mon Sep 17 00:00:00 2001
> From: Andy Whitcroft <apw@canonical.com>
> Date: Tue, 24 Sep 2013 16:10:46 +0100
> Subject: [PATCH] checkpatch: handle miss identified binary operators which
>  bump a close parenthesis
> 
> When we hit a close parenthesis, any binary operators we have without right
> hand sides cannot actually be binary if the code is correctly formatted.
> Go back and fix up any we get wrong.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  scripts/checkpatch.pl | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 47016c3..3d56e6e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1277,6 +1277,16 @@ sub annotate_values {
>  			} else {
>  				print "PAREN('$1')\n" if ($dbg_values > 1);
>  			}
> +			# Check for any pending binary operators, if they but up against this
> +			# bracket then they are really unary, correct them.
> +			my $pos = length($res) - 1;
> +			while ($pos >= 0 && substr($res, $pos, 1) eq 'N') {
> +				if (substr($var, $pos, 1) eq 'B') {
> +					substr($var, $pos, 1) = 'U';
> +					print "BINARY WACKED TO UNARY at $pos\n" if ($dbg_values > 1);
> +				}
> +				$pos--;
> +			}
> 
>  		} elsif ($cur =~ /^($Ident)\s*\(/o) {
>  			print "FUNC($1)\n" if ($dbg_values > 1);
> @@ -1331,12 +1341,12 @@ sub annotate_values {
>  		} elsif ($cur =~ /^(-(?![->])|\+(?!\+)|\*|\&\&|\&)/o) {
>  			my $variant;
> 
> -			print "OPV($1)\n" if ($dbg_values > 1);
>  			if ($type eq 'V') {
>  				$variant = 'B';
>  			} else {
>  				$variant = 'U';
>  			}
> +			print "OPV($1) -> $variant\n" if ($dbg_values > 1);
> 
>  			substr($var, length($res), 1, $variant);
>  			$type = 'N';
> -- 
> 1.8.1.2
> 

