Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaKLBWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:22:55 -0500
Received: from mail-bn1on0138.outbound.protection.outlook.com ([157.56.110.138]:24832
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753607AbaKLBWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:22:49 -0500
X-Greylist: delayed 1992 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2014 20:22:49 EST
Message-ID: <5462AE91.3070909@freescale.com>
Date: Tue, 11 Nov 2014 18:49:21 -0600
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <bhamciu1@freescale.com>,
        <R89243@freescale.com>, <Geoff.Thorpe@freescale.com>,
        <bhupesh.sharma@freescale.com>, <nir.erez@freescale.com>,
        <richard.schmitt@freescale.com>
Subject: Re: [PATCH 1/3 v3] drivers/bus: Added Freescale Management Complex
 APIs
References: <1412429015-30564-1-git-send-email-German.Rivera@freescale.com> <1412429015-30564-2-git-send-email-German.Rivera@freescale.com> <545B7C84.2090501@suse.de>
In-Reply-To: <545B7C84.2090501@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.49]
X-ClientProxiedBy: BLUPR05CA0060.namprd05.prod.outlook.com (10.141.20.30) To
 BY1PR0301MB1304.namprd03.prod.outlook.com (25.161.206.153)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1304;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1304;
X-Forefront-PRVS: 03932714EB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(164054003)(199003)(377454003)(479174003)(24454002)(189002)(51704005)(95666004)(77156002)(77096003)(62966003)(23746002)(21056001)(106356001)(50466002)(102836001)(97736003)(101416001)(86362001)(64126003)(105586002)(42186005)(36756003)(107046002)(33656002)(122386002)(31966008)(65806001)(99396003)(65956001)(87976001)(66066001)(40100003)(87266999)(76176999)(65816999)(64706001)(20776003)(47776003)(54356999)(4396001)(50986999)(92566001)(46102003)(2201001)(120916001)(19580395003)(19580405001)(80316001)(92726001)(59896002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1304;H:[10.214.85.150];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1304;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 07:49 AM, Alexander Graf wrote:
>
>
> On 04.10.14 15:23, J. German Rivera wrote:
>> From: "J. German Rivera" <German.Rivera@freescale.com>
>>
>> APIs to access the Management Complex (MC) hardware
>> module of Freescale LS2 SoCs. This patch includes
>> APIs to check the MC firmware version and to manipulate
>> DPRC objects in the MC.
>>
>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
>> ---
[cut]
>> diff --git a/drivers/bus/fsl-mc/dpmng.c b/drivers/bus/fsl-mc/dpmng.c
>> new file mode 100644
>> index 0000000..8a32448
>> --- /dev/null
>> +++ b/drivers/bus/fsl-mc/dpmng.c
>> @@ -0,0 +1,94 @@
>
> I don't think it's extremely obvious what "dpmng" means, so having some
> description at the head of the file makes things a lot easier to understand.
>
> This obviously applies to all files, not just this one ;).
>
Done

>> +/* Copyright 2013-2014 Freescale Semiconductor Inc.
[cut]
>> +
>> +int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info)
>> +{
>> +	struct mc_command cmd = { 0 };
>> +	int err;
>> +
>> +	cmd.header = mc_encode_cmd_header(DPMNG_CMDID_GET_VERSION,
>> +					  DPMNG_CMDSZ_GET_VERSION,
>> +					  MC_CMD_PRI_LOW, 0);
>> +
>> +	err = mc_send_command(mc_io, &cmd);
>> +	if (err)
>> +		return err;
>> +
>> +	DPMNG_RSP_GET_VERSION(cmd, mc_ver_info);
>
> Sorry if this came up before, but you have all these nicely abstracted
> helper functions (like mc_get_version()) to encapsulate command
> submission. Why do you need to call yet another macro inside of it to
> extract all of the fields?
>
> I would find a simple
>
>    mc_ver_info->revision = u64_dec(cmd.params[0], 0, 32);
>    mc_ver_info->major = u64_dec(cmd.params[0], 32, 32);
>    mc_ver_info->minor = u64_dec(cmd.params[1], 0, 8);
>
> right here a lot more easy to understand.
>
>> +	return 0;
>> +}
>> +
>> +int dpmng_reset_aiop(struct fsl_mc_io *mc_io, int aiop_tile_id)
>> +{
>> +	struct mc_command cmd = { 0 };
>> +
>> +	cmd.header = mc_encode_cmd_header(DPMNG_CMDID_RESET_AIOP,
>> +					  DPMNG_CMDSZ_RESET_AIOP,
>> +					  MC_CMD_PRI_LOW, 0);
>> +
>> +	DPMNG_CMD_RESET_AIOP(cmd, aiop_tile_id);
>
> The same goes here. Imagine this would be
>
>    cmd.params[0] |= u64_enc(0, 32, aiop_tile_id);
>
> then it would be immediately clear that we're modifying the parameters
> for cmd. With the macro as is, the occasional reader would have no idea
> what fields are different from before after the call.
>
> I think if you do this for all the functions in the patch, you will see
> that the code will suddenly become crystal clear to read.
>
Done.

[cut]
>> +static int mc_status_to_error(enum mc_cmd_status status)
>> +{
>> +	static const int mc_status_to_error_map[] = {
>> +		[MC_CMD_STATUS_OK] = 0,
>> +		[MC_CMD_STATUS_AUTH_ERR] = -EACCES,
>> +		[MC_CMD_STATUS_NO_PRIVILEGE] = -EPERM,
>> +		[MC_CMD_STATUS_DMA_ERR] = -EIO,
>> +		[MC_CMD_STATUS_CONFIG_ERR] = -ENXIO,
>> +		[MC_CMD_STATUS_TIMEOUT] = -ETIMEDOUT,
>> +		[MC_CMD_STATUS_NO_RESOURCE] = -ENAVAIL,
>> +		[MC_CMD_STATUS_NO_MEMORY] = -ENOMEM,
>> +		[MC_CMD_STATUS_BUSY] = -EBUSY,
>> +		[MC_CMD_STATUS_UNSUPPORTED_OP] = -ENOTSUPP,
>> +		[MC_CMD_STATUS_INVALID_STATE] = -ENODEV,
>> +	};
>> +
>> +	if (WARN_ON(status >= ARRAY_SIZE(mc_status_to_error_map)))
>> +		return -EINVAL;
>
> Unfortunately gcc may or may not make the enum signed. If it's signed,
> this check will not catch the case where the number is negative.
>
> Maybe cast status to u32 to explicitly make sure we catch negative
> values as well?
>
Done.

[cut]
>> +
>> +#define MC_CMD_PARAM_OP(_cmd, _param, _offset, _width, _type, _arg) \
>> +	((_cmd).params[_param] |= u64_enc((_offset), (_width), (_type)(_arg)))
>> +
>> +#define MC_RSP_PARAM_OP(_cmd, _param, _offset, _width, _type, _arg) \
>> +	((_arg) = (_type)u64_dec((_cmd).params[_param], (_offset), (_width)))
>> +
>> +#define MAKE_UMASK64(_width) \
>> +	((uint64_t)((_width) < 64 ? ((uint64_t)1 << (_width)) - 1 : -1))
>> +
>> +static inline uint64_t u64_enc(int lsoffset, int width, uint64_t val)
>> +{
>> +	return (uint64_t)(((uint64_t)val & MAKE_UMASK64(width)) << lsoffset);
>> +}
>> +
>> +static inline uint64_t u64_dec(uint64_t val, int lsoffset, int width)
>> +{
>> +	return (uint64_t)((val >> lsoffset) & MAKE_UMASK64(width));
>> +}
>
> I find u64_enc and u64_dec slightly too common for functions that would
> be defined inside of a device header. There's a good chance someone will
> introduce functions that are called the same in some other place and
> then we suddenly clash. How about mc_enc and mc_dec?
>
Sounds good.

[cut]
>> +
>> +/**
>> + * mc_write_command - writes a command to a Management Complex (MC) portal
>> + *
>> + * @portal: pointer to an MC portal
>> + * @cmd: pointer to a filled command
>> + */
>> +static inline void mc_write_command(struct mc_command __iomem *portal,
>> +				    struct mc_command *cmd)
>
> Why does this function live inside a header, not inside the only .c file
> that uses it?
>
Function moved to the .c file.

>
>> +{
>> +	int i;
>> +
>> +	/* copy command parameters into the portal */
>> +	for (i = 0; i < MC_CMD_NUM_OF_PARAMS; i++)
>> +		writeq(cmd->params[i], &portal->params[i]);
>
> I'm sure you will want to optimize this to only write parameters that
> are actually used later, but I guess for now it's good enough :). Better
> start simple.
>
>> +
>> +	/* submit the command by writing the header */
>> +	writeq(cmd->header, &portal->header);
>> +}
>> +
>> +/**
>> + * mc_read_response - reads the response for the last MC command from a
>> + * Management Complex (MC) portal
>> + *
>> + * @portal: pointer to an MC portal
>> + * @resp: pointer to command response buffer
>> + *
>> + * Returns MC_CMD_STATUS_OK on Success; Error code otherwise.
>> + */
>> +static inline enum mc_cmd_status mc_read_response(struct mc_command __iomem *
>> +						  portal,
>> +						  struct mc_command *resp)
>
> Same here
>
Function moved to the .c file

Thanks,

German

