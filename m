Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaEBTdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:33:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:57265 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751902AbaEBTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:33:00 -0400
Date: Fri, 2 May 2014 15:32:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ftrace function-graph: print the function name on
 all } lines
Message-ID: <20140502153249.1ee6aadd@gandalf.local.home>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402956EE7D16@G9W0745.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B402956EE7D16@G9W0745.americas.hpqcorp.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014 19:11:11 +0000
"Elliott, Robert (Server Storage)" <Elliott@hp.com> wrote:

> Using ftrace function-graph to examine the times consumed by
> functions, the time shows up on the line where the call is made
> if no other traceable functions were called by that function:
>  11)   0.672 us    |    cmd_alloc [hpsa]();
> 
> but the time shows up down by the } if the were other traceable
> functions called by that function:
>  11)               |              cmd_alloc [hpsa]() {
>  11)   0.129 us    |                cmd_free [hpsa]();
>  11)   0.106 us    |                cmd_free [hpsa]();
>  11)   2.014 us    |              }
> 
> On its own, the } line doesn't indicate which function it is
> closing, so grep cannot be used to search for all the times
> for this function. You have to write a parser.
> 
> The function name does get printed on those lines when the
> start of the function is off the trace, so I modified 
> trace_functions_graph.c to do that in all cases.
> 
>  11)               |    hpsa_scsi_ioaccel_raid_map [hpsa]() {
>  11)               |      hpsa_scsi_ioaccel_queue_command [hpsa]() {
>  11)               |        hpsa_scsi_ioaccel2_queue_command [hpsa]() {
>  11)   0.067 us    |          fixup_ioaccel_cdb [hpsa]();
>  11)   0.053 us    |          set_encrypt_ioaccel2 [hpsa]();
>  11)   0.199 us    |          enqueue_cmd_and_start_io [hpsa]();
>  11)   1.952 us    |        } /* hpsa_scsi_ioaccel2_queue_command [hpsa] */
>  11)   2.501 us    |      } /* hpsa_scsi_ioaccel_queue_command [hpsa] */
>  11)   3.093 us    |    } /* hpsa_scsi_ioaccel_raid_map [hpsa] */
>  11)   4.667 us    |  } /* hpsa_scsi_queue_command [hpsa] */
> 
> rather than:
>  11)               |    hpsa_scsi_ioaccel_raid_map [hpsa]() {
>  11)               |      hpsa_scsi_ioaccel_queue_command [hpsa]() {
>  11)               |        hpsa_scsi_ioaccel2_queue_command [hpsa]() {
>  11)   0.067 us    |          fixup_ioaccel_cdb [hpsa]();
>  11)   0.053 us    |          set_encrypt_ioaccel2 [hpsa]();
>  11)   0.199 us    |          enqueue_cmd_and_start_io [hpsa]();
>  11)   1.952 us    |        }
>  11)   2.501 us    |      }
>  11)   3.093 us    |    }
>  11)   4.667 us    |  }
> 
> Is this a change you would be interested in taking, or
> do you think that makes the output too cluttered?

Yes it is too cluttered. Please make this a tracing option that is
default off.

Thanks,

-- Steve

> 
> A potential patch (based on kernel-3.14) is:
> 
