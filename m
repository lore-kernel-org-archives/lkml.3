Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab3LFJ4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:56:46 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47594 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab3LFJ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:56:34 -0500
Date: Fri, 6 Dec 2013 09:56:26 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3] checkpatch: add DT compatible string documentation
 checks
Message-ID: <20131206095626.GD3248@bark>
References: <1386173031-17867-1-git-send-email-robherring2@gmail.com>
 <1386173563.30493.72.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386173563.30493.72.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 08:12:43AM -0800, Joe Perches wrote:
> On Wed, 2013-12-04 at 10:03 -0600, Rob Herring wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > This adds a simple check that any compatible strings in DeviceTree dts
> > files are present in Documentation/devicetree/bindings. Vendor prefixes
> > are also checked for existing in vendor-prefixes.txt These should be
> > temporary checks until we have more sophisticated binding schema checking.
> > 
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Andy Whitcroft <apw@canonical.com>
> > Cc: Joe Perches <joe@perches.com>
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> > ---
> > v3:
> > - Use a single message type UNDOCUMENTED_DT_STRING
> > - Ensure '+' is at beginning of the line
> > - Move vendor-prefixes.txt to variable
> > 
> > v2:
> > - Add vendor string checking against vendor-prefixes.txt
> > - Add '_', '.' and '+' as valid compatible string characters
> > - Use 'grep -E' instead of egrep
> > 
> >  scripts/checkpatch.pl | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 9c98100..3696366 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -2034,6 +2034,31 @@ sub process {
> >  			     "Use of $flag is deprecated, please use \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement->{$flag});
> >  		}
> >  
> > +# check for DT compatible documentation
> > +		if ($realfile =~ /\.dts/ && $rawline =~ /^\+\s*compatible\s*=/) {
> > +			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
> > +
> > +			foreach my $compat (@compats) {
> > +				my $compat2 = $compat;
> > +				my $dt_path = "Documentation/devicetree/bindings/";
> > +				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
> > +				`grep -Erq "$compat|$compat2" $dt_path`;
> > +				if ( $? >> 8 ) {
> > +					WARN("UNDOCUMENTED_DT_STRING",
> > +					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
> > +				}
> > +
> > +				my $vendor = $compat;
> > +				my $vendor_path = $dt_path . "vendor-prefixes.txt";
> > +				$vendor =~ s/^([a-zA-Z0-9]+)\,.*/$1/;
> > +				`grep -Eq "$vendor" $vendor_path`;
> > +				if ( $? >> 8 ) {
> > +					WARN("UNDOCUMENTED_DT_STRING",
> > +					     "DT compatible string vendor \"$vendor\" appears un-documented -- check $vendor_path\n" . $herecurr);
> > +				}
> > +			}
> > +		}

So this only works if you are in the top of the tree at the time when
you run it (unless I've missed something).  So it might be appropraite
to suppress this when the vendor-prefixes.txt file is not found.

-apw
