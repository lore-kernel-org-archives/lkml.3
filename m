Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaJAOHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:07:45 -0400
Received: from mout.web.de ([212.227.15.14]:62718 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaJAOHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:07:40 -0400
Message-ID: <542C0A9D.4030903@users.sourceforge.net>
Date: Wed, 01 Oct 2014 16:07:25 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Coccinelle <cocci@systeme.lip6.fr>, kernel-janitors@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Chi Pham <chidaph@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>
Subject: Re: [coccicheck PATCH 5/5] Deletion of unnecessary checks before
 specific function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <542BFB2C.5070609@users.sourceforge.net>
In-Reply-To: <542BFB2C.5070609@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:RH/1HDe8lfOMikufmx6wqmUfMqb81JFOFCUjr5jLOjvt6dZdluo
 kRA5pGBKqvgI+jXFYiWrLP90NxVzvZZ9DwZYlkilzTWw2H0n1/vcGiRfrk12e9AT1iZ8J4G
 J/Vp8x67ORMsWqQjuabZcyvcfKULY9XcHG0J7kGNL5SgfkcsoQ6Kt9aoZbfKwCjlRgvQk8e
 CRK4rWJGLp7N1qvqQ94Ew==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> If you are convinced that dropping the null tests is a good idea, then you 
>>> can submit the patch that makes the change to the relevant maintainers and 
>>> mailing lists.

>From bedf1cb3ddd162ee3b4c31cbb98d97431f70103d Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Mar 2014 19:40:43 +0100
Subject: [PATCH 5/5] Addition of a make file for build automation

This script can be used to combine some input files for the desired data output
which will eventually show update candidates for further source code review.
Some build targets were defined. Values for the used make variables can be
adjusted by parameters on the command line as usual.

A few implementation details might need more fine-tuning.
- Automatic determination of the Linux source directory from a calling
  make process

- Setting of an extra output directory for the generated files

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 scripts/coccinelle/deletions/makefile | 126 ++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 scripts/coccinelle/deletions/makefile

diff --git a/scripts/coccinelle/deletions/makefile
b/scripts/coccinelle/deletions/makefile
new file mode 100644
index 0000000..6464bae
--- /dev/null
+++ b/scripts/coccinelle/deletions/makefile
@@ -0,0 +1,126 @@
+SED=sed
+SPATCH=spatch.opt --sp-file
+RM=rm -f
+LINUX_SOURCE_DIR=/usr/src/linux-stable
+EXTRACT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER=list_input_parameter_validation1.cocci
+SQLITE=sqlite3
+SQLITE_IMPORT_SCRIPT=handle_function_list.sqlite
+SQLITE_IMPORT_SCRIPT_TEMPLATE=handle_function_list_template.sqlite
+RESULT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER=list_input_parameter_validation1.txt
+RESULT_SQL_DATA_BASE=result.db
+RESULT_FUNCTIONS_WITH_PREFIX=add_prefix-SQL.txt
+RESULT_FUNCTIONS_WITH_UNNECESSARY_CHECKS_AS_LIST=list_functions_with_unnecessary_checks1.txt
+RESULT_FUNCTIONS_WITH_UNNECESSARY_CHECKS_AS_PATCH=functions_with_unnecessary_checks1.diff
+LOG_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER=list_input_parameter_validation1-errors.txt
+LOG_LIST_FUNCTIONS_WITH_UNNECESSARY_CHECKS=list_functions_with_unnecessary_checks1-errors.txt
+LOG_PATCH_FUNCTIONS_WITH_UNNECESSARY_CHECKS=functions_with_unnecessary_checks1-errors.txt
+LIST_PATTERN_TEMPLATE=list_functions_with_unnecessary_checks_template1.cocci
+LIST_PATTERN=list_functions_with_unnecessary_checks1.cocci
+PATCH_PATTERN_TEMPLATE=delete_unnecessary_checks_template1.cocci
+PATCH_PATTERN=delete_unnecessary_checks1.cocci
+ESCAPING=XY=$$(< $(RESULT_FUNCTIONS_WITH_PREFIX)) \
+         && XY=$${XY/|/ } \
+         && XY=$${XY//%/\\%} \
+         && $(SED) "s%\# Alternation placeholder%$${XY//$$'\n'/$$'\\\\\n'}%"
+TEXT1=A pattern file was built from which a
+TEXT2=was generated. Good luck with source code review!
+
+default: build_update_candidate_list
+
+$(RESULT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER): \
+$(EXTRACT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER)
+	$(SPATCH) $(EXTRACT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER) \
+-dir $(LINUX_SOURCE_DIR) \
+> $@ 2> $(LOG_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER)
+
+# This replacement action is needed for the use case that the corresponding
+# variable was overridden.
+$(SQLITE_IMPORT_SCRIPT): $(SQLITE_IMPORT_SCRIPT_TEMPLATE)
+	$(SED) "s%import list_input_pointer_validation1\.txt%import $(subst
%,\%,$(RESULT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER))%" \
+$(SQLITE_IMPORT_SCRIPT_TEMPLATE) > $@
+
+$(RESULT_SQL_DATA_BASE) $(RESULT_FUNCTIONS_WITH_PREFIX): \
+$(RESULT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER) \
+$(SQLITE_IMPORT_SCRIPT)
+	@$(RM) $(RESULT_SQL_DATA_BASE)
+	$(SQLITE) -init $(SQLITE_IMPORT_SCRIPT) $(RESULT_SQL_DATA_BASE) \
+'select '\''   |  '\'' || function from positions group by function order by
function desc;' \
+> $(RESULT_FUNCTIONS_WITH_PREFIX)
+
+$(LIST_PATTERN): $(RESULT_FUNCTIONS_WITH_PREFIX)
+	$(ESCAPING) $(LIST_PATTERN_TEMPLATE) > $@
+
+$(PATCH_PATTERN): $(RESULT_FUNCTIONS_WITH_PREFIX)
+	$(ESCAPING) $(PATCH_PATTERN_TEMPLATE) > $@
+
+$(RESULT_FUNCTIONS_WITH_UNNECESSARY_CHECKS_AS_LIST): $(LIST_PATTERN)
+	$(SPATCH) $(LIST_PATTERN) -dir $(LINUX_SOURCE_DIR) \
+> $@ 2> $(LOG_LIST_FUNCTIONS_WITH_UNNECESSARY_CHECKS)
+
+$(RESULT_FUNCTIONS_WITH_UNNECESSARY_CHECKS_AS_PATCH): $(PATCH_PATTERN)
+	$(SPATCH) $(PATCH_PATTERN) -dir $(LINUX_SOURCE_DIR) \
+> $@ 2> $(LOG_PATCH_FUNCTIONS_WITH_UNNECESSARY_CHECKS)
+
+build_check_list generate_list_of_functions_which_check_their_single_parameter: \
+$(RESULT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER)
+	@echo 'The list of functions which check their single parameter was generated.'
+
+build_import_script: $(SQLITE_IMPORT_SCRIPT)
+	@echo 'A script was generated which should contain appropriate parameters for
a data base.'
+
+build_data_base: $(RESULT_SQL_DATA_BASE)
+	@echo 'A SQL data base was built.'
+
+build_alternation add_prefix_to_functions: build_data_base
+	@echo 'The function name list was converted to a component for a regular
expression.'
+
+build_list_pattern: $(LIST_PATTERN)
+	@echo '$(TEXT1) list can be generated.'
+
+build_patch_pattern: $(PATCH_PATTERN)
+	@echo '$(TEXT1) patch can be generated.'
+
+build_update_candidate_list show_list_of_update_candidates: build_list_pattern \
+$(RESULT_FUNCTIONS_WITH_UNNECESSARY_CHECKS_AS_LIST)
+	@echo 'The list of update candidates $(TEXT2)'
+
+build_patch show_update_suggestion: build_patch_pattern \
+$(RESULT_FUNCTIONS_WITH_UNNECESSARY_CHECKS_AS_PATCH)
+	@echo 'A patch file $(TEXT2)'
+
+all: build_update_candidate_list build_patch
+
+clean:
+	$(RM) *-errors.txt \
+$(LIST_PATTERN) \
+$(PATCH_PATTERN) \
+$(RESULT_FUNCTIONS_WITH_PREFIX) \
+$(RESULT_SQL_DATA_BASE) \
+$(RESULT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER) \
+$(SQLITE_IMPORT_SCRIPT)
+
+delete_data_base:
+	$(RM) $(RESULT_SQL_DATA_BASE) \
+$(RESULT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER)
+
+.PHONY: all \
+build_check_list \
+build_data_base \
+build_import_script \
+build_list_pattern \
+build_patch \
+build_patch_pattern \
+build_update_candidate_list \
+clean \
+default \
+delete_data_base \
+generate_list_of_functions_which_check_their_single_parameter \
+show_list_of_update_candidates \
+show_update_suggestion
+
+
+# The following input files should not need further actions here.
+$(EXTRACT_FUNCTIONS_THAT_CHECK_THEIR_SINGLE_PARAMETER) \
+$(SQLITE_IMPORT_SCRIPT_TEMPLATE) \
+$(LIST_PATTERN_TEMPLATE) \
+$(PATCH_PATTERN_TEMPLATE): ;
-- 
1.9.0


