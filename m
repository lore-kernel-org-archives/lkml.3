Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab3BUSSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:18:35 -0500
Received: from prdiron-2.llnl.gov ([128.15.143.172]:27028 "EHLO
	prdiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3BUSSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:18:33 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2013 13:18:33 EST
X-Attachments: 
Date: Thu, 21 Feb 2013 10:09:00 -0800
From: Ira Weiny <weiny2@llnl.gov>
To: "Husam Kahalah" <HKahalah@asaltech.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] infiniband-diags/saquery.c: switchinfo support added
Message-Id: <20130221100900.87b509d834fc0adc21b6f68b@llnl.gov>
In-Reply-To: <WC20130221094946.530170@asaltech.com>
References: <WC20130221094946.530170@asaltech.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First Thanks!  Some comments below.

On Thu, 21 Feb 2013 11:49:46 +0200
"Husam Kahalah" <HKahalah@asaltech.com> wrote:

> 
> From a77cadd4d81ac0e23db836d9382fd642d7e37897 Mon Sep 17 00:00:00 2001
> From: Husam kahalah < hkahalah@asaltech.com>
> Date: Sun, 3 Feb 2013 14:27:21 +0200
> Subject: [PATCH] infiniband-diags/saquery.c: switchinfo support added
>  
>  Added support in querying SwitchInfoRecords filtered by switch LID
>  
> Signed-off-by: Husam kahalah < hkahalah@asaltech.com>
> ---
>  src/saquery.c |   61 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 61 insertions(+), 0 deletions(-)
>  
> diff --git a/src/saquery.c b/src/saquery.c
> index d31d77d..753c7ac 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -74,6 +74,7 @@ struct query_params {
>    uint8_t scope;
>    uint8_t join_state;
>   int proxy_join;
> + ib_net16_t swir_lid;

We don't need this field or lid option.  Other records simply have an optional parameter to specify the lid.

The usage should be:

SwitchRecord [lid]

>  };
>  
>  struct query_cmd {
> @@ -481,6 +482,41 @@ static void dump_service_record(void *data)
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
> @@ -1090,6 +1126,19 @@ static int query_node_records(const struct query_cmd 
> *q, struct sa_handle * h,
>    &nr, sizeof(nr), dump_node_record);
>  }
>  
> +static int query_switchinfo_records(const struct query_cmd *q,
> + struct sa_handle * h, struct query_params *p,
> + int argc, char *argv[])
> +{
> +  ib_switch_info_record_t swir;
> + ib_net64_t comp_mask = 0;
> +
> +  memset(&swir, 0, sizeof(swir));
> +  CHECK_AND_SET_VAL(p->swir_lid, 16, 0, swir.lid, SWIR, LID);
> + return get_and_dump_any_records(h, IB_SA_ATTR_SWITCHINFORECORD, 0, 
> comp_mask,
> + &swir, 0, dump_switch_info_record);
> +}
> +
>  static int query_portinfo_records(const struct query_cmd *q,
>     struct sa_handle * h, struct query_params *p,
>     int argc, char *argv[])
> @@ -1342,6 +1391,8 @@ static const struct query_cmd query_cmds[] = {
>    "[[mlid]/[position]/[block]]", query_mft_records},
>    {"GUIDInfoRecord", "GIR", IB_SA_ATTR_GUIDINFORECORD,
>    "[[lid]/[block]]", query_guidinfo_records},
> +  {"SWITCHInfoRecord", "SWIR", IB_SA_ATTR_SWITCHINFORECORD,

I would change this to "SwitchInfoRecord"  Why did you use all caps?

> +  NULL, query_switchinfo_records},
>    {0}
>  };
>  
> @@ -1435,6 +1486,9 @@ static int process_opt(void *context, int ch, char 
> *optarg)
>   case 'S':
>    query_type = IB_SA_ATTR_SERVICERECORD;
>    break;
> + case 'W':
> + query_type = IB_SA_ATTR_SWITCHINFORECORD;
> + break;

I would rather not use this option here.  Just support the SwitchInfoRecord/SWIR query names.

>   case 'I':
>    query_type = IB_SA_ATTR_INFORMINFORECORD;
>    break;
> @@ -1551,6 +1605,9 @@ static int process_opt(void *context, int ch, char 
> *optarg)
>   case 'X':
>    p->proxy_join = strtoul(optarg, NULL, 0);
>    break;
> + case 22 :
> +  p->swir_lid = (ib_net16_t) strtoul(optarg, NULL, 0);
> + break;

As above no need for the additional option.

>    default:
>   return -1;
>   }
> @@ -1584,6 +1641,7 @@ int main(int argc, char **argv)
>    {"x", 'x', 0, NULL, "get LinkRecord info"},
>    {"c", 'c', 0, NULL, "get the SA's class port info"},
>    {"S", 'S', 0, NULL, "get ServiceRecord info"},
> +  {"W", 'W', 0, NULL, "get SwitchInfoRecord"},
>    {"I", 'I', 0, NULL, "get InformInfoRecord (subscription) info"},
>    {"list", 'D', 0, NULL, "the node desc of the CA's"},
>    {"src-to-dst", 1, 1, "<src:dst>", "get a PathRecord for"
> @@ -1633,6 +1691,9 @@ int main(int argc, char **argv)
>    {"scope", 21, 1, NULL, "Scope (MCMemberRecord)"},
>    {"join_state", 'J', 1, NULL, "Join state (MCMemberRecord)"},
>    {"proxy_join", 'X', 1, NULL, "Proxy join (MCMemberRecord)"},
> +  {"swir_lid", 22, 1, NULL,
> +  "switchInfo_lid (SwitchInfoRecord)"
> + " LID of switch port 0"},

As above no need for the additional option.

Thanks,
Ira

>    {0}
>    };
>  
> -- 
> 1.7.1
>  


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2@llnl.gov
