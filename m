Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaFMJzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:55:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63373 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaFMJzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:55:43 -0400
Subject: Re: [PATCH 4/4] tools lib traceevent: Fix and cleanup
 kvm_nested_vmexit tracepoints
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <20140613021157.484318137@goodmis.org>
References: <20140613021002.444608350@goodmis.org>
	 <20140613021157.484318137@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jun 2014 18:55:37 +0900
Message-ID: <1402653337.2178.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

2014-06-12 (목), 22:10 -0400, Steven Rostedt:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> Fix several issues of kvm_nested_vmexit[_inject]: field width aren't
> supported with pevent_print, rip was printed twice/incorrectly, SVM ISA
> was hard-coded, we don't use ':' to separate field names.
> 
> Link: http://lkml.kernel.org/r/8e6c02b22ea8136c139a91c69d6cc73b8c5c184b.1388855989.git.jan.kiszka@web.de
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  tools/lib/traceevent/plugin_kvm.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
> index 0d437837569f..0575e59c65f0 100644
> --- a/tools/lib/traceevent/plugin_kvm.c
> +++ b/tools/lib/traceevent/plugin_kvm.c
> @@ -330,19 +330,13 @@ static int kvm_emulate_insn_handler(struct trace_seq *s,
>  static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_record *record,
>  					    struct event_format *event, void *context)
>  {
> -	unsigned long long val;
> -
> -	pevent_print_num_field(s, " rip %0x016llx", event, "rip", record, 1);
> -
> -	if (pevent_get_field_val(s, event, "exit_code", record, &val, 1) < 0)
> +	if (print_exit_reason(s, record, event, "exit_code") < 0)
>  		return -1;
>  
> -	trace_seq_printf(s, "reason %s", find_exit_reason(2, val));
> -
> -	pevent_print_num_field(s, " ext_inf1: %0x016llx", event, "exit_info1", record, 1);
> -	pevent_print_num_field(s, " ext_inf2: %0x016llx", event, "exit_info2", record, 1);
> -	pevent_print_num_field(s, " ext_int: %0x016llx", event, "exit_int_info", record, 1);
> -	pevent_print_num_field(s, " ext_int_err: %0x016llx", event, "exit_int_info_err", record, 1);
> +	pevent_print_num_field(s, " info1 %llx", event, "exit_info1", record, 1);
> +	pevent_print_num_field(s, " info2 %llx", event, "exit_info2", record, 1);
> +	pevent_print_num_field(s, " int_info %llx", event, "exit_int_info", record, 1);
> +	pevent_print_num_field(s, " int_info_err %llx", event, "exit_int_info_err", record, 1);
>  
>  	return 0;
>  }
> @@ -350,7 +344,7 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_r
>  static int kvm_nested_vmexit_handler(struct trace_seq *s, struct pevent_record *record,
>  				     struct event_format *event, void *context)
>  {
> -	pevent_print_num_field(s, " rip %0x016llx", event, "rip", record, 1);
> +	pevent_print_num_field(s, "rip %lx ", event, "rip", record, 1);

s/%lx/%llx/

Otherwise this series and previous two cleanup patches look good to me.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


>  
>  	return kvm_nested_vmexit_inject_handler(s, record, event, context);
>  }



