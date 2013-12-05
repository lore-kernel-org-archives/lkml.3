Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3LENdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:33:00 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35848 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab3LENc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:32:56 -0500
Message-ID: <1386250370.20519.115.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC][PATCH 4/4] ima: added support for new kernel cmdline
 parameter ima_template_fmt
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, zohar@us.ibm.com,
        d.kasatkin@samsung.com, james.l.morris@oracle.com
Date: Thu, 05 Dec 2013 08:32:50 -0500
In-Reply-To: <1386245723.20519.111.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1383832849-17125-1-git-send-email-roberto.sassu@polito.it>
	 <1383832849-17125-5-git-send-email-roberto.sassu@polito.it>
	 <1386191125.20519.80.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <52A03DFE.7020403@polito.it>
	 <1386245723.20519.111.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120513-9332-0000-0000-000002638CBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 07:15 -0500, Mimi Zohar wrote:
> On Thu, 2013-12-05 at 09:49 +0100, Roberto Sassu wrote:
> > On 12/04/2013 10:05 PM, Mimi Zohar wrote:
> > > On Thu, 2013-11-07 at 15:00 +0100, Roberto Sassu wrote:

> > >> +static int __init ima_template_fmt_setup(char *str)
> > >> +{
> > >> +	int num_templates = ARRAY_SIZE(defined_templates);
> > >> +	char *str_ptr_start = str;
> > >> +	char *str_ptr_end = str_ptr_start;
> > >> +
> > >> +	if (ima_template)
> > >> +		return 1;
> > >> +
> > >> +	while (str_ptr_start != NULL) {
> > >> +		char field_id[IMA_TEMPLATE_FIELD_ID_MAX_LEN];
> > >> +		int len;
> > >> +
> > >> +		str_ptr_end = strpbrk(str_ptr_start, "|");
> > >> +		if (str_ptr_end == NULL)
> > >> +			len = str + strlen(str) - str_ptr_start;
> > >> +		else
> > >> +			len = str_ptr_end++ - str_ptr_start;
> > >> +
> > >> +		if (len >= IMA_TEMPLATE_FIELD_ID_MAX_LEN) {
> > >> +			pr_err("IMA: field too long, using template %s\n",
> > >> +			       CONFIG_IMA_DEFAULT_TEMPLATE);
> > >> +			return 1;
> > >> +		}
> > >> +
> > >> +		memcpy(field_id, str_ptr_start, len);
> > >> +		field_id[len] = '\0';
> > >> +		if (lookup_template_field(field_id) == NULL) {
> > >> +			pr_err("IMA: field '%s' not found, using template %s\n",
> > >> +			       field_id, CONFIG_IMA_DEFAULT_TEMPLATE);
> > >> +			return 1;
> > >> +		}
> > >> +
> > >> +		str_ptr_start = str_ptr_end;
> > >> +	}
> > >> +
> > >
> > > Roberto, looking this over again, I think this can be simplified by
> > > using strsep().
> > >
> > 
> > Hi Mimi
> > 
> > yes, the code can be simplified. However, I did not use strsep()
> > to avoid that this function modifies the kernel command line
> > (it replaces the passed separator character with '\0').
> > Since the custom format string is parsed again later, I also
> > have to revert changes made by strsep().
> 
> Somehow the code needs to be simplified and cleaned up.  For example,
> str_ptr_start/end need to be renamed to something simpler, like
> field/field_end or token/token_end. (Refer to Documentation/CodingStyle
> chapter 4 for variable naming style.)  Perhaps, instead of using
> strsep(), write a function to return a pointer to the field and field
> length.

Using lib/string.c:strcspn() might help.

Mimi

