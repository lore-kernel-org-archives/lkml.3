Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3CABh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:37:26 -0500
Received: from prdiron-2.llnl.gov ([128.15.143.172]:57430 "EHLO
	prdiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3CABhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:37:24 -0500
X-Attachments: 
Date: Thu, 28 Feb 2013 17:37:22 -0800
From: Ira Weiny <weiny2@llnl.gov>
To: "Husam Kahalah" <HKahalah@asaltech.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  infiniband-diags/saquery.c: switchinfo support added
Message-Id: <20130228173722.81b9d161a894b8324d5c5775@llnl.gov>
In-Reply-To: <WC20130228061138.140078@asaltech.com>
References: <WC20130228061138.140078@asaltech.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your mailer line wrapped the patch.  Could you resend.

Also, could you add this to doc/rst/saquery.8.in.rst

Thanks,
Ira

On Thu, 28 Feb 2013 08:11:38 +0200
"Husam Kahalah" <HKahalah@asaltech.com> wrote:

> From d61f2580b829fa2fc56aea15bd98ef3a607d9aba Mon Sep 17 00:00:00 2001
> 
> From: Husam kahalah <hkahalah@asaltech.com>
> Date: Mon, 25 Feb 2013 10:53:25 +0200
> Subject: [PATCH]  infiniband-diags/saquery.c: switchinfo support added
> 
> ---
>  src/saquery.c |   55 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 55 insertions(+), 0 deletions(-)
> 
> diff --git a/src/saquery.c b/src/saquery.c
> index d31d77d..6390bcd 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -481,6 +481,41 @@ static void dump_service_record(void *data)
>          cl_ntoh64(p_sr->service_data64[1]));
>  }
> 
> +static void dump_switch_info_record(void *data)
> +{
> +  ib_switch_info_record_t *p_sir = data;
> +
> +  printf("SwitchInfoRecord dump:\n"
> +        "\t\tRID\n"
> +        "\t\tlid.....................%u\n"
> +        "\t\tSwitchInfo dump:\n"
> +        "\t\tlin_cap.................0x%X\n"
> +        "\t\trand_cap................0x%X\n"
> +        "\t\tmcast_cap...............0x%X\n"
> +        "\t\tlin_top.................0x%X\n"
> +        "\t\tdef_port................%u\n"
> +        "\t\tdef_mcast_pri_port......%u\n"
> +        "\t\tdef_mcast_not_port......%u\n"
> +        "\t\tlife_state..............%u\n"
> +        "\t\tlids_per_port...........0x%X\n"
> +        "\t\tenforce_cap.............0x%X\n"
> +        "\t\tflags...................%u\n"
> +        "\t\tmcast_top...............0x%X\n",
> +        cl_ntoh16(p_sir->lid),
> +        cl_ntoh16(p_sir->switch_info.lin_cap),
> +        cl_ntoh16(p_sir->switch_info.rand_cap),
> +        cl_ntoh16(p_sir->switch_info.mcast_cap),
> +        cl_ntoh16(p_sir->switch_info.lin_top),
> +        p_sir->switch_info.def_port,
> +        p_sir->switch_info.def_mcast_pri_port,
> +        p_sir->switch_info.def_mcast_not_port,
> +        p_sir->switch_info.life_state,
> +        cl_ntoh16(p_sir->switch_info.lids_per_port),
> +        cl_ntoh16(p_sir->switch_info.enforce_cap),
> +        p_sir->switch_info.flags,
> +        cl_ntoh16(p_sir->switch_info.mcast_top));
> +}
> +
>  static void dump_inform_info_record(void *data)
>  {
>   char gid_str[INET6_ADDRSTRLEN];
> @@ -1150,6 +1185,24 @@ static int query_service_records(const struct 
> query_cmd *q, struct sa_handle * h
>    dump_service_record);
>  }
> 
> +static int query_switchinfo_records(const struct query_cmd *q,
> + struct sa_handle * h, struct query_params *p,
> + int argc, char *argv[])
> +{
> +  ib_switch_info_record_t swir;
> + ib_net64_t comp_mask = 0;
> + int lid = 0;
> +
> + if (argc > 0)
> +  parse_lid_and_ports(h, argv[0], &lid, NULL, NULL);
> +
> +  memset(&swir, 0, sizeof(swir));
> +  CHECK_AND_SET_VAL(lid, 16, 0, swir.lid, SWIR, LID);
> +
> + return get_and_dump_any_records(h, IB_SA_ATTR_SWITCHINFORECORD, 0, 
> comp_mask,
> + &swir, sizeof(swir), dump_switch_info_record);
> +}
> +
>  static int query_inform_info_records(const struct query_cmd *q,
>       struct sa_handle * h, struct query_params *p,
>       int argc, char *argv[])
> @@ -1342,6 +1395,8 @@ static const struct query_cmd query_cmds[] = {
>    "[[mlid]/[position]/[block]]", query_mft_records},
>    {"GUIDInfoRecord", "GIR", IB_SA_ATTR_GUIDINFORECORD,
>    "[[lid]/[block]]", query_guidinfo_records},
> +  {"SwitchInfoRecord", "SWIR", IB_SA_ATTR_SWITCHINFORECORD,
> +  "[lid]", query_switchinfo_records},
>    {0}
>  };
> 
> -- 
> 1.7.1


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2@llnl.gov
