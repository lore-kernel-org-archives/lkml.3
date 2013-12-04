Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab3LDQMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:12:50 -0500
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:44255 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753258Ab3LDQMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:12:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:2903:2914:3138:3139:3140:3141:3142:3354:3622:3653:3865:3866:3867:3868:3870:3871:3874:4250:4321:5007:6119:7576:7652:7875:7901:7903:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12291:12438:12517:12519:12555:12740:13019:13095,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spy94_5228af79b881a
X-Filterd-Recvd-Size: 3513
Message-ID: <1386173563.30493.72.camel@joe-AO722>
Subject: Re: [PATCH v3] checkpatch: add DT compatible string documentation
 checks
From: Joe Perches <joe@perches.com>
To: Rob Herring <robherring2@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Wed, 04 Dec 2013 08:12:43 -0800
In-Reply-To: <1386173031-17867-1-git-send-email-robherring2@gmail.com>
References: <1386173031-17867-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 10:03 -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This adds a simple check that any compatible strings in DeviceTree dts
> files are present in Documentation/devicetree/bindings. Vendor prefixes
> are also checked for existing in vendor-prefixes.txt These should be
> temporary checks until we have more sophisticated binding schema checking.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>

> ---
> v3:
> - Use a single message type UNDOCUMENTED_DT_STRING
> - Ensure '+' is at beginning of the line
> - Move vendor-prefixes.txt to variable
> 
> v2:
> - Add vendor string checking against vendor-prefixes.txt
> - Add '_', '.' and '+' as valid compatible string characters
> - Use 'grep -E' instead of egrep
> 
>  scripts/checkpatch.pl | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 9c98100..3696366 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2034,6 +2034,31 @@ sub process {
>  			     "Use of $flag is deprecated, please use \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement->{$flag});
>  		}
>  
> +# check for DT compatible documentation
> +		if ($realfile =~ /\.dts/ && $rawline =~ /^\+\s*compatible\s*=/) {
> +			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
> +
> +			foreach my $compat (@compats) {
> +				my $compat2 = $compat;
> +				my $dt_path = "Documentation/devicetree/bindings/";
> +				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
> +				`grep -Erq "$compat|$compat2" $dt_path`;
> +				if ( $? >> 8 ) {
> +					WARN("UNDOCUMENTED_DT_STRING",
> +					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
> +				}
> +
> +				my $vendor = $compat;
> +				my $vendor_path = $dt_path . "vendor-prefixes.txt";
> +				$vendor =~ s/^([a-zA-Z0-9]+)\,.*/$1/;
> +				`grep -Eq "$vendor" $vendor_path`;
> +				if ( $? >> 8 ) {
> +					WARN("UNDOCUMENTED_DT_STRING",
> +					     "DT compatible string vendor \"$vendor\" appears un-documented -- check $vendor_path\n" . $herecurr);
> +				}
> +			}
> +		}
> +
>  # check we are in a valid source file if not then ignore this hunk
>  		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
>  



