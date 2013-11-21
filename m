Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3KUOLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:11:37 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:53801 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3KUOLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:11:33 -0500
Message-ID: <1385043086.5452.32.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Linux-ima-devel] [PATCH-v2 0/6] ima: support per-measurement
 templates
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, zohar@us.ibm.com,
        linux-kernel@vger.kernel.org, james.l.morris@oracle.com,
        linux-ima-devel@lists.sourceforge.net
Date: Thu, 21 Nov 2013 09:11:26 -0500
In-Reply-To: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
References: <1384864428-3895-1-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112114-9332-0000-0000-000002406113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 13:33 +0100, Roberto Sassu wrote:
> Hi everyone
> 
> one functionality that is missing in the new template management mechanism
> is the possibility to specify a custom template format per-measurement entry.
> Until now, once the template is determined from the kernel configuration
> or from the kernel command line parameters 'ima_template' and ima_template_fmt',
> this template is used to generate all measurements entries in the list.
> 
> However, it is desirable to differentiate information included in measurement
> entries depending on the event type from which they are generated. To explain
> the usefulness of the proposed modification, I'll make an example.

Adding support for multiple templates in the measurement list at the
same time is a good idea.  Extending the IMA policy to define a per rule
template definition is also a good idea.  However, the example to
illustrate these ideas is unnecessarily complex.  I think the complexity
is due to using fields, that haven't yet been defined, that are
themselves complex.  Please try and find a simpler example.

(Still reviewing the code.)

thanks,

Mimi

> One feature coming soon is the addition of new template fields that represent
> LSM labels applied either to the current process and to the inode being
> measured. However, these information are not enough to capture the mapping
> between the executable code loaded for a given subject. Indeed, for example
> in SELinux, a type transition may occur if the type of the current process
> and the type of the inode being executed are matched in a 'type_transition'
> policy rule. In this case, the code should be mapped not to the label of the
> current process but instead to the label in the credentials (stored in the
> 'linux_binprm' structure) being installed during the execution of the execve()
> system call.
> 
> To correctly perform the mapping code - LSM label, it is needed to introduce
> a new template field to represent the LSM label in the 'linux_binprm' structure
> (e.g. with identifier 'target-subj') and a new IMA policy action
> (e.g. measure_log_all) to record a measurement for every event that match
> rule criteria, although the accessed inode has already been measured. Then,
> assuming that the format of the default template is "d-ng|n-ng|subj|obj"
> (digest + hash algo, long event name, subject LSM label, object LSM label),
> the policy to capture the mapping should be:
> 
> ---
> measure_log_all func=BPRM_CHECK mask=MAY_EXEC \
>     ima_template_fmt=d-ng|n-ng|subj|obj|target-subj
> measure_log_all func=FILE_MMAP mask=MAY_EXEC
> ---
> 
> In the first rule, the default template is overridden with a template that
> contains the label stored in the 'linux_binprm' structure. Thus, in the
> resulting measurements list, all entries that record file execution will
> include the additional template field, while those generated from the
> mapping into memory of shared libraries will contain only fields listed
> in the default template.
> 
> 
> 
> === UPDATE ===
> 
> This new version of the patch set includes two important updates in respect
> to the previous one. First, newly created templates are added to the created
> linked list (whose head is the first element of the 'defined_templates' array)
> to avoid duplicates. Second, instead of storing the template name or format
> strings in the IMA policy structure (ima_rule_entry), this patch set records
> directly the pointer to newly created template descriptors obtained from
> the function ima_get_template_desc(). Callers of ima_alloc_init_template()
> determine the template to be used to produce a new measurement entry
> (the default template or that stored in a matched policy rule) and supply
> it as argument to this function. The benefit of the latter change is that
> template lookup operations happen only during IMA initialization or the
> loading of a custom policy (before, lookup was done each time an event matches
> a rule with a custom template to translate the name or format string into
> a template descriptor).
> 
> Roberto Sassu
> 
> 
> Roberto Sassu (6):
>   ima: connect defined IMA templates through a linked list
>   ima: added new template helper lookup_template_desc_by_fmt()
>   ima: added ima_get_template_desc() for templates dynamic registration
>   ima: added ima_template and ima_template_fmt new policy options
>   ima: pass template descriptor to ima_alloc_init_template()
>   ima: use custom template obtained from a matched policy rule
> 
>  Documentation/ABI/testing/ima_policy     |  6 ++-
>  Documentation/security/IMA-templates.txt | 19 +++++----
>  security/integrity/ima/ima.h             | 14 +++++--
>  security/integrity/ima/ima_api.c         | 22 ++++++----
>  security/integrity/ima/ima_init.c        |  3 +-
>  security/integrity/ima/ima_main.c        |  6 ++-
>  security/integrity/ima/ima_policy.c      | 37 ++++++++++++++++-
>  security/integrity/ima/ima_template.c    | 70 ++++++++++++++++++++++++++++++--
>  8 files changed, 147 insertions(+), 30 deletions(-)
> 
> ------------------------------------------------------------------------------
> Shape the Mobile Experience: Free Subscription
> Software experts and developers: Be at the forefront of tech innovation.
> Intel(R) Software Adrenaline delivers strategic insight and game-changing 
> conversations that shape the rapidly evolving mobile landscape. Sign up now. 
> http://pubads.g.doubleclick.net/gampad/clk?id=63431311&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-ima-devel mailing list
> Linux-ima-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-ima-devel


